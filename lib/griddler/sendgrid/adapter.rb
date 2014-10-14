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
        ( params[key] || '' ).split(',')
      end

      def get_bcc
        return [] unless params[:envelope].present?
        envelope = json_to_hash(params[:envelope])
        bcc = if envelope.present?
                envelope["to"]
              else
                []
              end
        remove_addresses_from_bcc(remove_addresses_from_bcc(bcc, params[:to]),
                                  params[:cc])
      end

      def remove_addresses_from_bcc(bcc, addresses)
        return bcc unless addresses.present?
        if addresses.is_a?(Array)
          bcc -= addresses
        else
          bcc.delete(addresses) if bcc.present?
        end
        bcc
      end

      def json_to_hash(json_str)
        return [] unless json_str.present?
        JSON.parse(json_str || '')
      end

      def attachment_files
        params.delete('attachment-info')
        attachment_count = params[:attachments].to_i

        attachment_count.times.map do |index|
          params.delete("attachment#{index + 1}".to_sym)
        end
      end
    end
  end
end
