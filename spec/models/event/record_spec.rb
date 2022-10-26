require 'rails_helper'

module Event
  RSpec.describe Record, type: :model do
    describe "Validations" do
      it { is_expected.to validate_presence_of :action }
    end

    describe "Relationships" do
      it { is_expected.to belong_to(:actionable) }
    end
  end
end
