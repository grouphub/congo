account = Account.where(name: 'First Account').first

carrier = Carrier.create! \
  name: 'Blue Cross'

carrier_account = CarrierAccount.create! \
  name: 'My Broker Blue Cross',
  carrier_id: carrier.id,
  account_id: account.id

BenefitPlan.create! \
  account_id: account.id,
  carrier_account_id: carrier_account.id,
  name: 'Best Health Insurance PPO',
  is_enabled: true

