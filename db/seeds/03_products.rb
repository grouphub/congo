account = Account.where(name: 'First Account').first

carrier = Carrier.create! \
  name: 'Blue Cross'

account_carrier = AccountCarrier.create! \
  name: 'My Broker Blue Cross',
  carrier_id: carrier.id,
  account_id: account.id

Product.create! \
  account_id: account.id,
  account_carrier_id: account_carrier.id,
  name: 'Best Health Insurance PPO'

