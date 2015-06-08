class EnrollmentJob < ActiveJob::Base
  queue_as :default

  if ENV['AWS_REGION']
    rescue_from ActiveJob::DeserializationError do |e|
      Shoryuken.logger.error e
      Shoryuken.logger.error e.backtrace.join("\n")
    end
  end

  def perform(application_id)
    redlock = Redlock::Client.new([Rails.application.config.redis.url])

    # Lock will expire in five minutes if not relinquished.
    redlock.lock("application_#{application_id}_enrollment", 5 * 60 * 1000) do |lock_acquired|
      unless lock_acquired
        Rails.logger.info("Another worker is attempting to enroll application with ID #{application_id}")
        return
      end

      application = Application.find(application_id)
      data = application.to_pokitdok
      response = nil

      begin
        response = pokitdok.enrollment(data)
        meta = attempt['meta'] || {}
        activity_id = meta['activity_id']

        application.update_attributes! \
          submitted_by_id: submitted_by_id,
          submitted_on: DateTime.now,
          activity_id: activity_id
      rescue StandardError => e
        response = JSON.parse(e.response.body)
        error_type = e.class

        application.update_attributes \
          errored_by_id: submitted_by_id
      end

      if application.application_status
        application.application_status.update_attributes! \
          payload: response.to_json
      else
        ApplicationStatus.create! \
          application_id: application,
          payload: response.to_json
      end
    end
  end
end

