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
        )
      end

      private

      attr_reader :params

      def recipients(key)
        encoded = Mail::Encodings.address_encode(params[key] || '')
        Mail::AddressList.new(encoded).addresses
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

      def attachment_files
        attachment_count.times.map do |index|
          extract_file_at(index)
        end
      end

      def attachment_count
        params[:attachments].to_i
      end

      def extract_file_at(index)
        filename = attachment_filename(index)

        params.delete("attachment#{index + 1}".to_sym).tap do |file|
          if filename.present?
            file.original_filename = filename
          end
        end
      end

      def attachment_filename(index)
        attachment_info.fetch("attachment#{index + 1}", {})["filename"]
      end

      def attachment_info
        @attachment_info ||= JSON.parse(params.delete("attachment-info") || "{}")
      end
    end
  end
end
