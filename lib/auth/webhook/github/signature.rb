module Auth
  module Webhook
    module Github
      class Signature
        class MissingPrefix < StandardError; end
        class InvalidPayload < StandardError; end

        protected attr_reader :digest
        private_class_method  :new

        PREFIX = 'sha256='.freeze
        SECRET_KEY = ENV['GITHUB_WEBHOOK_SECRET_KEY']

        Generate = ->(payload) do
          raise InvalidPayload unless payload.is_a? String

          sha256 = OpenSSL::Digest.new('sha256')
          digest = PREFIX + OpenSSL::HMAC.hexdigest(sha256, SECRET_KEY, payload)

          Signature[digest]
        end

        def self.[](digest)
          new(digest)
        end

        def initialize(digest)
          raise MissingPrefix unless digest.starts_with? PREFIX

          @digest = digest
        end

        def ==(other)
          return false unless other.is_a? self.class

          Rack::Utils.secure_compare(self.digest, other.digest)
        end
      end

      private_constant :Signature
    end
  end
end
