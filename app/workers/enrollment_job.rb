class PaymentJob < ActiveJob::Base
  queue_as :default

  rescue_from ActiveJob::DeserializationError do |e|
    Shoryuken.logger.error ex
    Shoryuken.logger.error ex.backtrace.join("\n")
  end

  # TODO: May need a lock
  def perform(application_id)
    redlock = Redlock.new(Rails.application.config.redis.url)

    # Lock will expire in five minutes if not relinquished.
    lock = redlock.lock("application_#{application_id}_enrollment", 5 * 60 * 1000)

    if lock
      Rails.logger.info("Another worker is attempting to enroll application with ID #{application_id}")
      return
    end

    application = Application.find(application_id)
    pokitdok = PokitDok::PokitDok.new \
      Rails.application.config.pokitdok.client_id,
      Rails.application.config.pokitdok.client_secret

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

    redlock.unlock(lock)
  end
end

