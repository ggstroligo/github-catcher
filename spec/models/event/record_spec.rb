require 'rails_helper'

module Event
  RSpec.describe Event, type: :model do
    describe "Validations" do
      it { is_expected.to validate_presence_of :action }
    end

    describe "Relationships" do
      it { is_expected.to belongs_to(:actionable) }
    end
  end
end
