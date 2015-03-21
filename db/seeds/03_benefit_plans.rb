account = Account.where(name: 'First Account').first

carrier = Carrier.create! \
  name: 'Blue Cross',
  properties: {
    name: 'Blue Cross',
    npi: '1467560003',
    first_name: 'Brad',
    last_name: 'Bluecross',
    service_types: ['health_benefit_plan_coverage'],
    trading_partner_id: 'MOCKPAYER'
  }

carrier_account = CarrierAccount.create! \
  name: 'My Broker Blue Cross',
  carrier_id: carrier.id,
  account_id: account.id

BenefitPlan.create! \
  account_id: account.id,
  carrier_account_id: carrier_account.id,
  name: 'Best Health Insurance PPO',
  is_enabled: true,
  description_html: "<h1>Best Health Insurance PPO</h1>\n<p>An example plan.</p>",
  description_markdown: "# Best Health Insurance PPO\n\nAn example plan.",
  properties: {
    description_html: "<h1>Best Health Insurance PPO</h1>\n<p>An example plan.</p>",
    description_markdown: "# Best Health Insurance PPO\n\nAn example plan."
  }

