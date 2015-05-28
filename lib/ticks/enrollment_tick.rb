class EnrollmentTick < Tick
  queue_name :enrollment

  def tick
    clock.logger.info 'Enrollment tick. Enrollment is currently disabled.'

    # clock.logger.info 'Enrollment tick.'

    # Application.where('submitted_on IS NOT NULL AND completed_on IS NULL').find_each do |application|
    #   EnrollmentJob.perform_later(application.id)
    # end
  end
end

