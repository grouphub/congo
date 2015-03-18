Account.create! \
  name: 'Admin',
  tagline: 'GroupHub administrative account',
  plan_name: 'admin',
  properties: {
    name: 'Admin',
    tagline: 'GroupHub administrative account',
    plan_name: 'admin'
  }

first_account = Account.create! \
  name: 'First Account',
  tagline: 'First account is best account!',
  plan_name: 'premier',
  properties: {
    name: 'First Account',
    tagline: 'First account is best account!',
    plan_name: 'premier'
  }

Token.create! \
  account_id: first_account.id,
  name: 'Example API Token'

