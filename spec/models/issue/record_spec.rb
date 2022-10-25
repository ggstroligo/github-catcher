require 'rails_helper'

module Issue
  RSpec.describe Record do
    describe "Validations" do
      subject { described_class.new(number: 1, title: "Title") }

      it { should validate_uniqueness_of :number }
      it { is_expected.to validate_presence_of :number }
      it { is_expected.to validate_presence_of :title }
    end

    describe "Relationships" do
      it { is_expected.to have_many(:events).class_name("Event::Record") }
    end
  end
end