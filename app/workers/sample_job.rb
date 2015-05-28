class SampleJob < ActiveJob::Base
  queue_as :default

  if ENV['AWS_REGION']
    rescue_from ActiveJob::DeserializationError do |e|
      Shoryuken.logger.error ex
      Shoryuken.logger.error ex.backtrace.join("\n")
    end
  end

  def perform
    Rails.logger.info '===='
    Rails.logger.info 'Test'
    Rails.logger.info '===='
    Rails.logger.info 'This is the output of a test job.'
  end
end

