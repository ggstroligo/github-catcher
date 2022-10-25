require 'rails_helper'

module Issue
  module Event
    RSpec.describe Entity do
      describe "#persisted?" do
        it "checks inclusion of :id attribute" do
          # Arrange
          params = { action: "opened", number: 1, issue_id: 1 }
          persisted_params = { id: 1, action: "opened", issue_id: 1, created_at: Time.current, updated_at: Time.current}

          entity           = described_class.new(**params)
          persisted_entity = described_class.new(**persisted_params)

          # Act
          result = entity.persisted?
          persisted_result = persisted_entity.persisted?

          # Assert
          expect(result).to be_falsey
          expect(persisted_result).to be_truthy
        end
      end
    end
  end
end