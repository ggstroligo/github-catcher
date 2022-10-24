RSpec.describe BaseService do
  describe ".call" do
    it "always return a `Result` object" do
      # Arrange
      service = Class.new(described_class) do
        steps :run

        private def run = success!(:result)
      end
      # Act
      result = service.()

      # Assert
      expect(result).to be_a(::Result)
    end

    context "Failures" do
      context "when called without defined steps" do
        it "returns an failure `Result` object with error" do
          # Arrange
          service = Class.new(described_class)

          # Act
          result = service.call

          # Assert
          error_message = "`#{service}` must define at least one `step` in it's defition body"

          expect(result).to be_a(::Result)
          expect(result.failure?).to be_truthy
          expect(result.reason).to eq(:internal_error)
          expect(result[:message]).to eq(error_message)
        end
      end

      context "when the return of any step is not an Result object" do
        it "returns an failure `Result` object with error" do
          # Arrange
          service = Class.new(described_class) do
            steps :step

            private def step = :not_a_result_object
          end

          # Act
          result = service.call

          # Assert
          error_message = "`#{service}#step` must return an `Result` object"

          expect(result).to be_a(::Result)
          expect(result.failure?).to be_truthy
          expect(result.reason).to eq(:internal_error)
          expect(result[:message]).to eq(error_message)
        end
      end

      context "when called with undefined private methods stated on steps" do
        it "raises StepNotDefined exception" do
          # Arrange
          service = Class.new(described_class) do
            steps :undefined_step
          end

          # Act & Assert
          expect { service.call }.to raise_error(::BaseService::StepNotDefined)
        end
      end

      context "when it fails in any step" do
        it "halts the execution and return the last failure `Result` object" do
          # Arrange
          service = Class.new(described_class) do
            steps :continue, :fail, :continue

            private def fail = failure!(:halt_on_fail)
            private def continue = success!(:continued)
          end

          # Act
          result = service.call

          # Assert
          expect(result.failure?).to be_truthy
          expect(result.reason).to eq(:halt_on_fail)
        end
      end
    end

    context "Successes" do
      context "when a service run entirely without failures or exceptions" do
        it "returns an successful `Result` object" do
          # Arrange
          service = Class.new(described_class) do
            steps :double, :to_s
            def initialize(number:) = @number = number

            private def double = success!(:doubled, number: @number * 2)
            private def to_s = success!(:ok, number: result[:number].to_s)
          end
          number = 10

          # Act
          result = service.(number:)

          # Assert
          expect(result).to be_a(Result)
          expect(result.success?).to be_truthy
          expect(result[:number]).to eq("20")
        end
      end
    end
  end

  describe ".steps" do
    it "set `@execution_steps` instance variable" do
      # Arrange
      service = Class.new(described_class)

      # Act
      service.send(:steps, :validate, :create)

      # Assert
      expect(service.instance_values["execution_steps"]).to be_a(Set)
      expect(service.instance_values["execution_steps"]).to eq([:create, :validate].to_set)
    end

    context "when called outside definition of a class" do
      it "raises `NoMethodError` for private class method call" do
        expect { BaseService.steps([]) }.to raise_error(NoMethodError)
      end
    end
  end
end