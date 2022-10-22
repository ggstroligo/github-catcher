require 'rails_helper'

module Auth
  module User
    RSpec.describe BasicAuth do
      describe "#authenticate!" do
        context "given valid login and invalid password" do
          it "return false" do
            # Arrange
            ENV['USER_LOGIN'] = 'test_login'
            ENV['USER_PASSWORD'] = 'test_password'

            requested_login = 'test_login'
            requested_password = 'invalid_password'

            # Act
            result = described_class.authenticate!(
              requested_login,
              requested_password
            )

            # Assert
            expect(result).to be_falsey
          end
        end

        context "given invalid login and valid password" do
          it "return false" do
            # Arrange
            ENV['USER_LOGIN'] = 'test_login'
            ENV['USER_PASSWORD'] = 'test_password'

            requested_login = 'invalid_login'
            requested_password = 'test_password'

            # Act
            result = described_class.authenticate!(
              requested_login,
              requested_password
            )

            # Assert
            expect(result).to be_falsey
          end
        end

        context "given both invalid login and password" do
          it "return false" do
            # Arrange
            ENV['USER_LOGIN'] = 'test_login'
            ENV['USER_PASSWORD'] = 'test_password'

            requested_login = 'invalid_login'
            requested_password = 'invalid_password'

            # Act
            result = described_class.authenticate!(
              requested_login,
              requested_password
            )

            # Assert
            expect(result).to be_falsey
          end
        end

        context "given valid login and password" do
          it "return true" do
            # Arrange
            ENV['USER_LOGIN'] = 'test_login'
            ENV['USER_PASSWORD'] = 'test_password'

            requested_login = 'test_login'
            requested_password = 'test_password'

            # Act
            result = described_class.authenticate!(
              requested_login,
              requested_password
            )

            # Assert
            expect(result).to be_truthy
          end
        end

        context "given nil inputs" do
          it "return false" do
            # Arrange
            ENV['USER_LOGIN'] = 'test_login'
            ENV['USER_PASSWORD'] = 'test_password'

            requested_login = nil
            requested_password = nil

            # Act
            result = described_class.authenticate!(
              requested_login,
              requested_password
            )

            # Assert
            expect(result).to be_falsey
          end
        end

        context "given numeric inputs" do
          it "return false" do
            # Arrange
            ENV['USER_LOGIN'] = 'test_login'
            ENV['USER_PASSWORD'] = 'test_password'

            requested_login = 1
            requested_password = 2

            # Act
            result = described_class.authenticate!(
              requested_login,
              requested_password
            )

            # Assert
            expect(result).to be_falsey
          end
        end
      end
    end
  end
end