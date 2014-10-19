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

account = Account.first

[admin, bob, alice].each do |user|
  AccountUser.create! \
    user_id: user.id,
    account_id: account.id
end

