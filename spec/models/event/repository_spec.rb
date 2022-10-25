require 'rails_helper'

module Event
  RSpec.describe Repository, type: :model do
    describe ".insert" do
      it "inserts an line into the database" do
        # Arrange
        resource = create :issue
        resource_id = resource.id
        resource_type = resource.class.name
        action = "created"

        events_count = ::Event::Record.count

        # Act
        result = described_class.insert(action:, resource_id:, resource_type:)

        # Assert
        expect(result).to be_a(::Event::Record)
        expect(::Event::Record.count).to eq(events_count+1)
      end
    end
  end
end
