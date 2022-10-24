class BaseService
  def self.call(**args)
    service = new(**args)

    return NoStepToRunError[self] if @execution_steps.blank?

    @result = Result::Failure[reason: :not_yet_performed]

    @execution_steps.inject(@result) do |_, step|
      raise StepNotDefined, "Missing private method :#{step}" unless private_method_defined?(step)
      result = service.send(step)

      break ReturnIsNotResultError[self, step] if !result.is_a?(::Result)
      break result if result.failure?

      result
    end
  end

  class StepNotDefined < NoMethodError; end

  NoStepToRunError = ->(klass) do
    Result::Failure[
      reason: :internal_error,
      message: "`#{klass}` must define at least one `step` in it's defition body"
    ]
  end

  ReturnIsNotResultError = ->(klass, step) do
    Result::Failure[
      reason: :internal_error, 
      message: "`#{klass}##{step}` must return an `Result` object"
    ]
  end

  def self.steps(*steps)
    @execution_steps = steps.to_set.freeze
  end

  def success!(reason = :ok, **data)
    @result = Result::Success[reason:, **data]
  end

  def failure!(reason = :error, **data)
    @result = Result::Failure[reason:, **data]
  end

  private attr_reader :result
  private_class_method :new, :steps
  private_constant :ReturnIsNotResultError, :NoStepToRunError
end


