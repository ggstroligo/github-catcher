module Issue
  module Event
    RSpec.describe Create, type: :model do
      describe ".call" do
        describe "Successes" do
          it "stores a new Issue::Record and Event::Record" do
            # Arrange
            issue = { title: "Random Title", number: 1 }
            event = { action: :opened }

            # Act & Assert
            expect { described_class.(issue:, event:) }.to change { ::Issue::Record.count }.by(1)
            expect { described_class.(issue:, event:) }.to change { ::Event::Record.count }.by(1)
          end

          it "return a successful Result object with created issue and event data" do
            # Arrange
            issue = { title: "Random Title", number: 1 }
            event = { action: :opened }

            # Act
            result = described_class.(issue:, event:)

            # Assert
            expect(result).to be_a(::Result)
            expect(result.success?).to be_truthy
            expect(result.reason).to eq(:created)
            expect(result.data).to include(:issue)
            expect(result.data).to include(:event)
          end

          context "when issue is already stored" do
            it "do not create a new Issue::Record, but update its title if needed" do
              # Arrange
              persisted_issue = create :issue, title: "Title", number: 1
              issue = { title: "Edited Title", number: 1 }
              event = { action: :opened }

              # Act & Assert
              expect { described_class.(issue:, event:) }.to change { ::Issue::Record.count }.by(0)
              expect { described_class.(issue:, event:) }.to change { ::Event::Record.count }.by(1)
              expect {
                described_class.(issue:, event:)
                persisted_issue.reload
              }.to change { persisted_issue.title }.from("Title").to("Edited Title")
            end
          end
        end

        describe "Failures" do
          context "given invalid kwargs" do
            it "raises ArgumentError" do
              # Arrange
              params = { random: :kwargs, to: :raise_error }

              # Act & Assert
              expect { described_class.(**params) }.to raise_error ArgumentError
            end
          end

          context "given unpermitted event action" do
            before do
              stub_const "Issue::Event::ACTIONS", %w(permitted_action)
            end

            it "returns an failure Result object" do
              # Arrange
              issue = { title: "Random Title", number: 1 }
              event = { action: :unpermitted_action }

              # Act
              result = described_class.(issue:, event:)

              # Assert
              expect(result).to be_a(::Result)
              expect(result.failure?).to be_truthy
              expect(result.reason).to eq(:unpermitted_action)
              expect(result[:action]).to eq(:unpermitted_action)
              expect(result[:permitted]).to eq(["permitted_action"])
            end
          end

          context "given invalid event or issue params" do
            it "returns an failure Result object" do
              # Arrange
              issue = { pspsps: "come here cat" }
              event = { tsctsc: "come here dog" }

              # Act
              result = described_class.(issue:, event:)

              # Assert
              expect(result).to be_a(::Result)
              expect(result.failure?).to be_truthy
              expect(result.reason).to eq(:invalid_params)
              expect(result.data).to include(:invalid_params)
            end
          end

        end
      end
    end
  end
end