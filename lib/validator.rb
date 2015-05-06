module Validator
  attr_reader :failure_message

  def validate(validation_method, failure_message)
    unless failed? || send(validation_method)
      fail_with_message(failure_message)
    end
    valid?
  end

  def failed?
    @failed == true
  end

  def valid?
    @failed != true
  end

  private

  attr_writer :failed, :failure_message

  def fail_with_message(failure_message)
    self.failure_message = { error: failure_message }
    self.failed = true
  end

end
