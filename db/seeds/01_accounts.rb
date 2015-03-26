Account.create! \
  name: 'Admin',
  tagline: 'GroupHub Administrative Account',
  plan_name: 'admin',
  properties: {
    name: 'Admin',
    tagline: 'GroupHub Administrative Account',
    plan_name: 'admin'
  }

first_account = Account.create! \
  name: 'First Account',
  tagline: 'First account is best account!',
  plan_name: 'premier',
  properties: {
    name: 'First Account',
    tagline: 'First account is best account!',
    plan_name: 'premier',
    tax_id: '123',
    first_name: 'Barry',
    last_name: 'Broker',
    phone: '(555) 555-5555'
  }

Token.create! \
  account_id: first_account.id,
  name: 'Example API Token'

