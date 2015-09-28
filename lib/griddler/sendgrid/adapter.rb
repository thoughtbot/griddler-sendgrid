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
          to: recipients(:to) + envelope["to"].to_a,
          cc: recipients(:cc),
          attachments: attachment_files,
        )
      end

      private

      attr_reader :params

      def envelope
        @envelope ||= JSON.parse(params[:envelope] || '{}')
      end

      def recipients(key)
        ( params[key] || '' ).split(',')
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
