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

    # TODO: Write a method to translate application properties into PokitDok request data.
    data = sample_data

    begin
      response = pokitdok.enrollment(data)
      meta = attempt['meta'] || {}
      activity_id = meta['activity_id']

      attempt.create! \
        response: response,
        activity_id: activity_id,
        application_id: application_id

      application.update_attributes \
        submitted_by_id: submitted_by_id,
        submitted_on: DateTime.now
    rescue StandardError => e
      response = JSON.parse(e.response.body)
      error_type = e.class

      attempt.create! \
        response: response,
        error_type: error_type,
        application_id: application_id

      application.update_attributes \
        errored_by_id: submitted_by_id
    end

    redlock.unlock(lock)
  end

  # TODO: Get rid of this
  def sample_data
    {
      action: 'Change',
      broker: {
        name: 'MONEY TALKS BROKERAGE',
        tax_id: '123356799',
        account_numbers: ['123', '456']
      },
      dependents: [],
      master_policy_number: 'ABCD012354',
      payer: {
        tax_id: '654456654'
      },
      purpose: 'Original',
      reference_number: '12456',
      sponsor: {
        tax_id: '999888777'
      },
      subscriber: {
        address: {
          city: 'CAMP HILL',
          county: 'CUMBERLAND',
          line: '100 MARKET ST',
          line2: 'APT 3G',
          postal_code: '17011',
          state: 'PA'
        },
        benefit_status: 'Active',
        benefits: [
          {
            begin_date: 'Sat Jun  1 00:00:00 1996',
            benefit_type: 'Health',
            coordination_of_benefits: [
              {
                group_or_policy_number: '890111',
                payer_responsibility: 'Primary',
                status: 'Unknown'
              }
            ],
            late_enrollment: false,
            maintenance_type: 'Addition'
          },
          {
            begin_date: 'Sat Jun  1 00:00:00 1996',
            benefit_type: 'Dental',
            late_enrollment: false,
            maintenance_type: 'Addition'
          },
          {
            begin_date: 'Sat Jun  1 00:00:00 1996',
            benefit_type: 'Vision',
            late_enrollment: false,
            maintenance_type: 'Addition'
          }
        ],
        birth_date: 'Fri Aug 16 00:00:00 1940',
        contacts: [
          {
            communication_number2: '7172341240',
            communication_type2: 'Work Phone Number',
            primary_communication_number: '7172343334',
            primary_communication_type: 'Home Phone Number'
          }
        ],
        eligibility_begin_date: 'Thu May 23 00:00:00 1996',
        employment_status: 'Full-time',
        first_name: 'JOHN',
        gender: 'Male',
        group_or_policy_number: '123456001',
        handicapped: false,
        last_name: 'DOE',
        maintenance_reason: 'Active',
        maintenance_type: 'Addition',
        member_id: '123456789',
        middle_name: 'P',
        relationship: 'Self',
        ssn: '123456789',
        subscriber_number: '123456789',
        substance_abuse: false,
        tobacco_use: false
      },
      trading_partner_id: 'MOCKPAYER'
    }
  end
end

