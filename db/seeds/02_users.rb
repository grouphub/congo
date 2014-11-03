admin_account = Account.where(name: 'Admin').first

admin = User.create! \
  first_name: 'GroupHub',
  last_name: 'Admin',
  email: 'admin@grouphub.io',
  password: 'testtest'

Role.create! \
  user_id: admin.id,
  account_id: admin_account.id,
  name: 'admin'

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
  name: 'broker'

Role.create! \
  user_id: admin.id,
  account_id: first_account.id,
  name: 'group_admin'

Role.create! \
  user_id: bob.id,
  account_id: first_account.id,
  name: 'customer'

Role.create! \
  user_id: alice.id,
  account_id: first_account.id,
  name: 'customer'

