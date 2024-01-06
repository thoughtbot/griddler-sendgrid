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
        params.merge!(
          headers: to_utf8(params[:headers]),
          dkim: to_utf8(params[:dkim]),
          "content-ids": to_utf8(params[:"content-ids"]),
          email: to_utf8(params[:email]),
          to: to_utf8(params[:to]),
          html: to_utf8(params[:html]),
          from: to_utf8(params[:from]),
          sender_ip: to_utf8(params[:sender_ip]),
          text: to_utf8(params[:text]),
          spam_report: to_utf8(params[:spam_report]),
          envelope: to_utf8(params[:envelope]),
          attachments: to_utf8(params[:attachments]),
          subject: to_utf8(params[:subject]),
          spam_score: to_utf8(params[:spam_score]),
          "attachment-info": to_utf8(params["attachment-info"]),
          charsets: to_utf8(params[:charsets]),
          spf: to_utf8(params[:spf])
        )

        params.merge(
          to: recipients(:to).map(&:format),
          cc: recipients(:cc).map(&:format),
          bcc: get_bcc,
          attachments: attachment_files,
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
        charsets = JSON.parse(params[:charsets]).symbolize_keys
        charsets.transform_values!{ "UTF-8" }
      rescue JSON::ParserError
        {}
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

      def to_utf8(str)
        str = str&.force_encoding(Encoding::UTF_8)
        return str if str&.valid_encoding?

        str = str&.force_encoding(Encoding::ISO_8859_1)
        str&.encode(Encoding::UTF_8, :invalid => :replace, :undef => :replace)
      end
    end
  end
end
