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
          to: recipients(:to),
          cc: recipients(:cc),
          bcc: get_bcc,
          attachments: attachment_files,
        )
      end

      private

      attr_reader :params

      def recipients(key)
        raw = ( params[key] || '' )
        if raw.index(">")
          raw.split(">,").map do |addr|
            addr.strip!
            addr << ">" unless addr.index(">")
            addr
          end
        else
          raw.split(',')
        end
      end

      def get_bcc
        if bcc = bcc_from_envelope(params[:envelope])
          remove_addresses_from_bcc(
            remove_addresses_from_bcc(bcc, params[:to]),
            params[:cc]
          )
        else
          []
        end
      end

      def remove_addresses_from_bcc(bcc, addresses)
        if addresses.is_a?(Array)
          bcc -= addresses
        elsif addresses && bcc
          bcc.delete(addresses)
        end
        bcc
      end

      def bcc_from_envelope(envelope)
        JSON.parse(envelope)["to"] if envelope.present?
      end

      def attachment_files
        info = JSON.parse params.delete('attachment-info')
        attachment_count = params[:attachments].to_i
        attachment_count.times.map do |index|
          params.delete("attachment#{index + 1}".to_sym).tap{|file|
            # fix filename
            file.original_filename = info["attachment#{index + 1 }"]['filename']
          }
        end
      end
    end
  end
end
