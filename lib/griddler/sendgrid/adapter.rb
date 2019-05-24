module Griddler
  module Sendgrid
    class Adapter
      def initialize(params)
        @params = params
      end

      def self.normalize_params(params)
        adapter = new(params)
        adapter.normalize_params
      end

      def normalize_params
        params.merge(
          to: recipients(:to).map(&:format),
          cc: recipients(:cc).map(&:format),
          bcc: get_bcc,
          attachments: attachment_files,
          vendor_specific: {
            attachment_info: processed_attachment_info
          },
          charsets: charsets,
          spam_report: {
            report: params[:spam_report],
            score: params[:spam_score],
          }
        )
      end

      private

      attr_reader :params

      def recipients(key)
        Mail::AddressList.new(params[key] || '').addresses
      rescue Mail::Field::IncompleteParseError
        []
      end

      def get_bcc
        if bcc = bcc_from_envelope
          bcc - recipients(:to).map(&:address) - recipients(:cc).map(&:address)
        else
          []
        end
      end

      def bcc_from_envelope
        JSON.parse(params[:envelope])["to"] if params[:envelope].present?
      end

      def charsets
        return {} unless params[:charsets].present?
        JSON.parse(params[:charsets]).symbolize_keys
      rescue JSON::ParserError
        {}
      end

      def processed_attachment_info
        attachment_count.times.map do |index|
          {
            file: extract_file_at(index),
            type: attachment_info_at(index)['type'],
            content_id: attachment_info_at(index)['content-id']
          }
        end
      end

      def attachment_files
        attachment_count.times.map do |index|
          extract_file_at(index)
        end
      end

      def attachment_count
        params[:attachments].to_i
      end

      def extract_file_at(index)
        filename = attachment_info_at(index)['filename']
        params.fetch("attachment#{index + 1}".to_sym).tap do |file|
          if filename.present?
            file.original_filename = filename
          end
        end
      end

      def attachment_info_at(index)
        attachment_info.fetch("attachment#{index + 1}", {})
      end

      def attachment_info
        @attachment_info ||= JSON.parse(params["attachment-info"] || "{}")
      end
    end
  end
end
