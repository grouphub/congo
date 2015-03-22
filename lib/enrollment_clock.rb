require File.expand_path('../../config/boot', __FILE__)
require File.expand_path('../../config/environment', __FILE__)
require 'clockwork'

class EnrollmentClock
  def initialize(*args)
    @args = args
  end

  def start
    Clockwork.every(1.minute, 'tick') do
      Rails.logger.info 'Tick. Enrollment is currently disabled.'

      # Rails.logger.info 'Tick.'

      Application.where('submitted_by_id IS NOT NULL AND sent_by_id IS NULL').find_each do |application|
        EnrollmentJob.perform_async(application.id)
      end
    end
  end
end

