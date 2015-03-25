account = Account.where(name: 'First Account').first

# Admin-created carrier account and benefit plan

carrier = Carrier.create! \
  name: 'Blue Shield',
  properties: {
    name: 'Blue Shield',
    npi: '1530731902',
    trading_partner_id: 'MOCKPAYER',
    service_types: ['health_benefit_plan_coverage'],
    tax_id: '234',
    first_name: 'Billy',
    last_name: 'Blueshield'
  }

carrier_account = CarrierAccount.create! \
  name: 'Admin Blue Shield',
  carrier_id: carrier.id,
  properties: {
    name: 'Admin Blue Shield',
    carrier_slug: 'blue_shield',
    broker_number: '123',
    brokerage_name: 'Example Brokerage',
    tax_id: '234',
    account_type: 'broker'
  }

BenefitPlan.create! \
  carrier_account_id: carrier_account.id,
  is_enabled: true,
  name: 'Admin Health Insurance PPO',
  description_html: "<h1>Admin Health Insurance PPO</h1>\n<p>An example plan.</p>",
  description_markdown: "# Admin Health Insurance PPO\n\nAn example plan.",
  properties: {
    name: 'Admin Health Insurance PPO',
    description_html: "<h1>Admin Health Insurance PPO</h1>\n<p>An example plan.</p>",
    description_markdown: "# Admin Health Insurance PPO\n\nAn example plan."
  }

# Broker-created carrier account and benefit plan

carrier = Carrier.create! \
  name: 'Blue Cross',
  properties: {
    name: 'Blue Cross',
    npi: '1467560003',
    trading_partner_id: 'MOCKPAYER',
    service_types: ['health_benefit_plan_coverage'],
    tax_id: '123',
    first_name: 'Brad',
    last_name: 'Bluecross'
  }

carrier_account = CarrierAccount.create! \
  name: 'My Broker Blue Cross',
  carrier_id: carrier.id,
  account_id: account.id,
  properties: {
    name: 'My Broker Blue Cross',
    carrier_slug: 'blue_cross',
    broker_number: '234',
    brokerage_name: 'Example Brokerage',
    tax_id: '345',
    account_type: 'broker'
  }

BenefitPlan.create! \
  account_id: account.id,
  carrier_account_id: carrier_account.id,
  is_enabled: true,
  name: 'Best Health Insurance PPO',
  description_html: "<h1>Best Health Insurance PPO</h1>\n<p>An example plan.</p>",
  description_markdown: "# Best Health Insurance PPO\n\nAn example plan.",
  properties: {
    name: 'Best Health Insurance PPO',
    description_html: "<h1>Best Health Insurance PPO</h1>\n<p>An example plan.</p>",
    description_markdown: "# Best Health Insurance PPO\n\nAn example plan."
  }

