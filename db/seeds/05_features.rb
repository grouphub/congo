account = Account.where(name: 'First Account').first

Feature.create! \
  name: 'eligibility_modal',
  description: 'Allow certain broker accounts to check eligibility.',
  enabled_for_all: false,
  account_ids: [account.id]

