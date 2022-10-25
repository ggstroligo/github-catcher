require 'rails_helper'

module Issue
  RSpec.describe Entity do
    describe "#persisted?" do
      it "checks inclusion of :id attribute" do
        # Arrange
        params = { title: "Some title", number: 1 }
        persisted_params = { id: 1, title: "Some title", number: 1, created_at: Time.current, updated_at: Time.current}

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