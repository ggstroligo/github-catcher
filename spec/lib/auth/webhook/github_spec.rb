require 'rails_helper'

module Auth
  module Webhook
    RSpec.describe Github do
      describe "#authenticate!" do
        context "given a signature matching with payload and secret key" do
          it "return true" do
            # Arrange
            ENV['GITHUB_WEBHOOK_SECRET_KEY']='SECRET_KEY'
            payload = { any: 'payload' }.to_json

            # Act
            incoming_digest = 'sha256=' + OpenSSL::HMAC.hexdigest(
              OpenSSL::Digest.new('sha256'),
              'SECRET_KEY',
              "{\"any\":\"payload\"}"
            )

            result = described_class.authenticate!(payload, incoming_digest)

            # Assert
            expect(result).to be_truthy
          end
        end

        context "given a signature that does not matches with payload and secret key" do
          it "return true" do
            # Arrange
            ENV['GITHUB_WEBHOOK_SECRET_KEY']='SECRET_KEY'
            payload = { any: 'payload' }.to_json

            # Act
            incoming_digest = 'sha256=' + OpenSSL::HMAC.hexdigest(
              OpenSSL::Digest.new('sha256'),
              'ANOTHER_KEY',
              "ANOTHER PAYLOAD"
            )

            result = described_class.authenticate!(payload, incoming_digest)

            # Assert
            expect(result).to be_falsey
          end
        end

      end
    end
  end
end
