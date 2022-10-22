module Auth
  module Webhook
    module Github
      module_function

      def authenticate!(payload_body, x_hub_signature)
        signature = Signature::Generate.(payload_body)
        incoming_signature = Signature[x_hub_signature]

        signature == incoming_signature
      end
    end
  end
end