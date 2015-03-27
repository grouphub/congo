require File.expand_path('../../config/boot', __FILE__)
require File.expand_path('../../config/environment', __FILE__)
require 'clockwork'

class Clock
  def initialize(*args)
    @args = args
  end

  def start
    Clockwork.every(1.minute, 'tick') do
      Rails.logger.info 'Tick. Enrollment is currently disabled.'

      # Rails.logger.info 'Tick.'

      # Application.where('submitted_on IS NOT NULL AND completed_on IS NULL').find_each do |application|
      #   EnrollmentJob.perform_later(application.id)
      # end
    end

    Clockwork.every(1.minute, 'tick') do
      Rails.logger.info 'Tick. Payment is currently disabled.'

      # Rails.logger.info 'Tick.'

      # Account.find_each do |account|
      #   if account.needs_to_pay?
      #     PaymentJob.perform_later(account)
      #   end
      # end
    end
  end
end

