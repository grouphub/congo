#!/usr/bin/env bundle exec rails runner

require 'pokitdok'

pokitdok = PokitDok::PokitDok.new \
  Rails.application.config.pokitdok.client_id,
  Rails.application.config.pokitdok.client_secret

data = {
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

data = {}

File.open("#{File.dirname __FILE__}/enrollment.json") do |f|
  # begin
  #   response = pokitdok.enrollment(data)
  # rescue StandardError => e
  #   f.puts JSON.pretty_generate(JSON.parse(e.response.body))
  # end

  f.puts JSON.pretty_generate(response)
end

