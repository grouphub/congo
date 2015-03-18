account = Account.where(name: 'First Account').first

carrier = Carrier.create! \
  name: 'Blue Cross',
  properties: {
    name: 'Blue Cross',
    npi: '1467560003',
    trading_partner_id: 'MOCKPAYER'
    service_types: ['health_benefit_plan_coverage'],
    tax_id: '123',
    first_name: 'Brad',
    last_name: 'Bluecross'
  }

carrier_account = CarrierAccount.create! \
  name: 'My Broker Blue Cross',
  carrier_id: carrier.id,
  account_id: account.id

BenefitPlan.create! \
  account_id: account.id,
  carrier_account_id: carrier_account.id,
  name: 'Best Health Insurance PPO',
  is_enabled: true

