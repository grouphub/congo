carrier = Carrier.create! \
  name: 'Blue Cross'

account = Account.where(name: 'First Account').first

Product.create! \
  account_id: account.id,
  carrier_id: carrier.id,
  name: 'Best Health Insurance PPO'

