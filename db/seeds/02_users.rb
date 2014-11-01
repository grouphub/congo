admin_account = Account.where(name: 'Admin Account').first

admin = User.create! \
  first_name: 'GroupHub',
  last_name: 'Admin',
  email: 'admin@grouphub.io',
  password: 'testtest'

Role.create! \
  user_id: admin.id,
  account_id: admin_account.id,
  role: 'admin'

first_account = Account.where(name: 'First Account').first

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

Role.create! \
  user_id: admin.id,
  account_id: first_account.id,
  role: 'broker'

Role.create! \
  user_id: bob.id,
  account_id: first_account.id,
  role: 'customer'

Role.create! \
  user_id: alice.id,
  account_id: first_account.id,
  role: 'customer'

