admin = User.create! \
  name: 'admin',
  email: 'admin@grouphub.io',
  password: 'testtest'

bob = User.create! \
  name: 'bob',
  email: 'bob@first-account.com',
  password: 'testtest'

alice = User.create! \
  name: 'alice',
  email: 'alice@first-account.com',
  password: 'testtest'

account = Account.first

[admin, bob, alice].each do |user|
  AccountUser.create! \
    user_id: user.id,
    account_id: account.id
end

