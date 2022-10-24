RSpec.describe Result do
  describe ".[]" do
    it "initialize an instance of `Result`" do
      expect { Result[success: true] }.to_not raise_error
      expect(Result[success: true]).to be_an_instance_of(described_class)
    end
  end

  describe "#failure?" do
    context "when `Result` is a failure" do
      it "return true" do
        result = Result::Failure[]

        expect(result.failure?).to be_truthy
      end
    end

    context "when `Result` is a success" do
      it "return false" do
        result = Result::Success[]

        expect(result.failure?).to be_falsey
      end
    end
  end

  describe "#success?" do
    context "when `Result` is a failure" do
      it "return false" do
        subject = Result::Failure[]

        expect(subject.success?).to be_falsey
      end
    end

    context "when `Result` is a success" do
      it "return false" do
        subject = Result::Success[]

        expect(subject.success?).to be_truthy
      end
    end
  end

  describe "#on_success" do
    it "exposes the resulted data and reason to a block" do
      # Arrange
      data = {any: 'data'}
      reason = :ok
      subject = Result::Success[reason:, **data]


      # Assert
      expect { |b| subject.on_success(:ok, &b) }.to yield_with_args(data, reason)
    end

    it "returns self" do
      # Arrange
      subject = Result::Success[]

      # Act
      result = subject.on_success

      # Assert
      expect(result).to be_equal(subject)
      expect(result).to_not be_equal(Result::Success[])
    end

    context "when result is successful without explicit reason" do
      it "is hooked only by `on_success`" do
        # Arrange
        hooks = { with_reason: 0, without_reason: 0 }
        subject = Result::Success[]

        # Act
        subject
          .on_success(:ok) { hooks[:with_reason] += 1 }
          .on_success      { hooks[:without_reason] += 1 }

        # Assert
        expect(hooks[:with_reason]).to be_eql(0)
        expect(hooks[:without_reason]).to be_eql(1)
      end
    end

    context "when result is successful with reason :ok" do
      it "is hooked only by `on_success` and `reason: :ok`" do
        # Arrange
        hooks = { with_reason: 0, without_reason: 0 }
        subject = Result::Success[reason: :ok]

        # Act
        subject
          .on_success(:ok) { hooks[:with_reason] += 1 }
          .on_success      { hooks[:without_reason] += 1 }

        # Assert
        expect(hooks[:with_reason]).to be_eql(1)
        expect(hooks[:without_reason]).to be_eql(0)
      end
    end
  end

  describe "#on_failure" do
    it "exposes the resulted data and reason to a block" do
      # Arrange
      data = {any: 'data'}
      reason = :ok
      subject = Result::Success[reason:, **data]


      # Assert
      expect { |b| subject.on_success(:ok, &b) }.to yield_with_args(data, reason)
    end

    it "returns self" do
      # Arrange
      subject = Result::Success[]

      # Act
      result = subject.on_success

      # Assert
      expect(result).to be_equal(subject)
      expect(result).to_not be_equal(Result::Success[])
    end

    context "when result failed without explicit reason" do
      it "is hooked only by `on_failure`" do
        # Arrange
        hooks = { with_reason: 0, without_reason: 0 }
        subject = Result::Failure[]

        # Act
        subject
          .on_failure(:error) { hooks[:with_reason] += 1 }
          .on_failure         { hooks[:without_reason] += 1 }

        # Assert
        expect(hooks[:with_reason]).to be_eql(0)
        expect(hooks[:without_reason]).to be_eql(1)
      end
    end

    context "when result failed with reason :error" do
      it "is hooked only by `on_failure` and `reason: :error`" do
        # Arrange
        hooks = { with_reason: 0, without_reason: 0 }
        subject = Result::Failure[reason: :error]

        # Act
        subject
          .on_failure(:error) { hooks[:with_reason] += 1    }
          .on_failure         { hooks[:without_reason] += 1 }

        # Assert
        expect(hooks[:with_reason]).to be_eql(1)
        expect(hooks[:without_reason]).to be_eql(0)
      end
    end
  end
end