require 'rails_helper'

module Issue
  RSpec.describe Repository, type: :model do
    describe ".insert_or_update" do
      context "given new issue" do
        it "insert issue to table" do
          # Arrange
          params = {title: "A title", number: 1}
          issue_rows_count = Issue::Record.count

          # Act
          result = described_class.insert_or_update(**params)

          # Assert
          expect(Issue::Record.count).to eq(issue_rows_count + 1)
          expect(result).to be_a(Issue::Entity)
        end
      end

      context "given duplicate number with diff title" do
        it "updates the title" do
          # Arrange
          persisted = create :issue, title: "A title", number: 1
          params = {title: "Totally different title", number: 1}
          issue_rows_count = Issue::Record.count

          # Act
          result = described_class.insert_or_update(**params)

          # Assert
          expect(Issue::Record.count).to eq(issue_rows_count)
          expect(persisted.reload.title).to eq("Totally different title")
        end
      end
    end
  end
end
