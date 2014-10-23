admin = User.create! \
  first_name: 'Adam',
  last_name: 'Admin',
  email: 'admin@grouphub.io',
  password: 'testtest'

bob = User.create! \
  first_name: 'Bob',
  last_name: 'Smith',
  email: 'bob@first-account.com',
  password: 'testtest'

alice = User.create! \
  first_name: 'Alice',
  last_name: 'Doe',
  email: 'alice@first-account.com',
  password: 'testtest'

account = Account.where(name: 'First Account').first

Role.create! \
  user_id: admin.id,
  account_id: account.id,
  role: 'broker'

Role.create! \
  user_id: bob.id,
  account_id: account.id,
  role: 'customer'

Role.create! \
  user_id: alice.id,
  account_id: account.id,
  role: 'customer'

