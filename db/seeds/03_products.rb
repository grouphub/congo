account = Account.where(name: 'First Account').first

Product.create! \
  account_id: account.id,
  name: 'Best Health Insurance PPO'

