first_account = Account.where(name: 'Top Tier Brokerage').first
second_account = Account.where(name: 'Second Account').first

# Pre-populated list of carriers

path = "#{Rails.root}/spec/data/carrier-response.json"
if File.exists?(path)
  carrier_response = JSON.load(File.read(path))
  carrier_data = carrier_response['data']

  carrier_data.each do |carrier_datum|
    Carrier.create! \
      account_id: nil, # Admin carrier
      name: carrier_datum['name'],
      properties: {
        name: carrier_datum['name'],
        trading_partner_id: carrier_datum['id'],
        supported_transactions: carrier_datum['supported_transactions'],
        is_enabled: carrier_datum['is_enabled'],
        npi: nil,
        service_types: nil,
        tax_id: nil,
        first_name: nil,
        last_name: nil,
        address_1: nil,
        address_2: nil,
        city: nil,
        state: nil,
        zip: nil,
        phone: nil
      }
  end
else
  Rails.logger.warn "There is no carrier response data at \"#{path}\"."
  Rails.logger.warn 'Try generating it by running `bundle exec rake data:carriers:fetch`.'
end

# Admin-created carrier account and benefit plan

carrier = Carrier.create! \
  account_id: nil, # Admin carrier
  name: 'Sample Admin Carrier',
  properties: {
    name: 'Sample Admin Carrier',
    trading_partner_id: 'MOCKPAYER',
    supported_transactions: ['555'],
    is_enabled: true,
    npi: '1530731902',
    service_types: ['health_benefit_plan_coverage'],
    tax_id: '234',
    first_name: 'Sally',
    last_name: 'Sampleadmincarrier',
    address_1: '123 Somewhere Lane',
    address_2: 'Apt. 123',
    city: 'Somewhereville',
    state: 'CA',
    zip: '94444',
    phone: '444-444-4444'
  }

BenefitPlan.create! \
  account_id: nil, # Admin benefit plan
  carrier_id: carrier.id,
  is_enabled: true,
  name: 'Admin Health Insurance PPO',
  description_html: "<h1>Admin Health Insurance PPO</h1>\n<p>An example plan.</p>",
  description_markdown: "# Admin Health Insurance PPO\n\nAn example plan.",
  properties: {
    name: 'Admin Health Insurance PPO',
    description_html: "<h1>Admin Health Insurance PPO</h1>\n<p>An example plan.</p>",
    description_markdown: "# Admin Health Insurance PPO\n\nAn example plan.",
    plan_type: 'foo',
    exchange_plan: 'bar',
    small_group: 'baz',
    group_id: '234'
  }

# =============
# First Account
# =============

# Broker-created carrier account and benefit plan

carrier = Carrier.create! \
  account_id: first_account.id,
  name: 'Sample Broker Carrier',
  properties: {
    name: 'Sample Broker Carrier',
    trading_partner_id: 'MOCKPAYER',
    supported_transactions: ['555'],
    is_enabled: true,
    npi: '1467560003',
    service_types: ['health_benefit_plan_coverage'],
    tax_id: '123',
    first_name: 'Samuel',
    last_name: 'Samplebrokercarrier',
    address_1: '123 Somewhere Lane',
    address_2: 'Apt. 123',
    city: 'Somewhereville',
    state: 'CA',
    zip: '94444',
    phone: '444-444-4444'
  }

carrier_account = CarrierAccount.create! \
  account_id: first_account.id,
  carrier_id: carrier.id,
  name: 'My Broker Blue Cross',
  properties: {
    name: 'My Broker Blue Cross',
    carrier_slug: 'blue_cross',
    broker_number: '234',
    brokerage_name: 'Example Brokerage',
    tax_id: '345',
    account_type: 'broker'
  }

benefit_plan = BenefitPlan.create! \
  account_id: first_account.id,
  carrier_id: carrier.id,
  carrier_account_id: carrier_account.id,
  is_enabled: true,
  name: 'Best Health Insurance PPO',
  description_html: "<h1>Best Health Insurance PPO</h1>\n<p>An example plan.</p>",
  description_markdown: "# Best Health Insurance PPO\n\nAn example plan.",
  properties: {
    name: 'Best Health Insurance PPO',
    description_html: "<h1>Best Health Insurance PPO</h1>\n<p>An example plan.</p>",
    description_markdown: "# Best Health Insurance PPO\n\nAn example plan.",
    plan_type: 'foo',
    exchange_plan: 'bar',
    small_group: 'baz',
    group_id: '235'
  }

account_benefit_plan = AccountBenefitPlan.create! \
  account_id: first_account.id,
  carrier_id: carrier.id,
  carrier_account_id: carrier_account.id,
  benefit_plan_id: benefit_plan.id,
  properties: {

  }

# ==============
# Second Account
# ==============

carrier = Carrier.create! \
  account_id: second_account.id,
  name: 'Second Sample Broker Carrier',
  properties: {
    name: 'Second Sample Broker Carrier',
    trading_partner_id: 'MOCKPAYER',
    supported_transactions: ['555'],
    is_enabled: true,
    npi: '1467560003',
    service_types: ['health_benefit_plan_coverage'],
    tax_id: '123',
    first_name: 'Samuel',
    last_name: 'Samplebrokercarrier',
    address_1: '123 Somewhere Lane',
    address_2: 'Apt. 123',
    city: 'Somewhereville',
    state: 'CA',
    zip: '94444',
    phone: '444-444-4444'
  }

carrier_account = CarrierAccount.create! \
  account_id: second_account.id,
  carrier_id: carrier.id,
  name: 'Second My Broker Blue Cross',
  properties: {
    name: 'Second My Broker Blue Cross',
    carrier_slug: 'blue_cross',
    broker_number: '234',
    brokerage_name: 'Example Brokerage',
    tax_id: '345',
    account_type: 'broker'
  }

benefit_plan = BenefitPlan.create! \
  account_id: second_account.id,
  carrier_id: carrier.id,
  carrier_account_id: carrier_account.id,
  is_enabled: true,
  name: 'Second Best Health Insurance PPO',
  description_html: "<h1>Best Health Insurance PPO</h1>\n<p>An example plan.</p>",
  description_markdown: "# Best Health Insurance PPO\n\nAn example plan.",
  properties: {
    name: 'Second Best Health Insurance PPO',
    description_html: "<h1>Best Health Insurance PPO</h1>\n<p>An example plan.</p>",
    description_markdown: "# Best Health Insurance PPO\n\nAn example plan.",
    plan_type: 'foo',
    exchange_plan: 'bar',
    small_group: 'baz',
    group_id: '235'
  }

account_benefit_plan = AccountBenefitPlan.create! \
  account_id: second_account.id,
  carrier_id: carrier.id,
  carrier_account_id: carrier_account.id,
  benefit_plan_id: benefit_plan.id,
  properties: {

  }

