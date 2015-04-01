class SampleJob < ActiveJob::Base
  queue_as :default

  rescue_from ActiveJob::DeserializationError do |e|
    Shoryuken.logger.error ex
    Shoryuken.logger.error ex.backtrace.join("\n")
  end

  def perform
    Rails.logger.info '===='
    Rails.logger.info 'Test'
    Rails.logger.info '===='
    Rails.logger.info 'This is the output of a test job.'
  end
end

