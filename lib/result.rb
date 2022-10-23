# This module aims to facilitate the creation
# of control flows and make them more readable,
# through visible hooks with blocks instead of \
# implicit calls.
# e.g:
# > user = { first_name: 'John', last_name: 'Doe' }
# > result = Result::Success[reason: :found_user, **user]
# > result.on_success(:found_user) do |data|
# >   puts "#{data[:first_name]} #{data[:last_name]}" }
# > end
# John Doe

class Result
  Success = ->(reason: nil, **data) do
    Result[success: true, reason:, data: { **data }]
  end

  Failure = ->(reason: nil, **data) do
    Result[success: false, reason:, data: { **data }]
  end

  def initialize(success:, reason: nil, data: {})
    @success = !!success
    @reason = reason
    @data = data
  end

  attr_reader :data
  private attr_reader :reason, :success
  private_class_method :new

  def success? = self.success
  def failure? = !self.success

  def self.[](success:, reason: nil, data: {})
    new(success:, reason:, data:)
  end

  def on_success(reason = nil)
    return self if failure?
    return self if !hooked_by_reason?(reason)

    yield(self.data, self.reason) if block_given?
    self
  end

  def on_failure(reason = nil, &block)
    return self if success?
    return self unless hooked_by_reason?(reason)

    yield(self.data, self.reason) if block_given?
    self
  end

  private
  def hooked_by_reason?(reason)
    reason.eql?(self.reason)
  end
end
