# ========
# Accounts
# ========

admin_account = Account.where(name: 'Admin').first
first_account = Account.where(name: 'First Account').first

# =====
# Admin
# =====

admin = User.create! \
  first_name: 'GroupHub',
  last_name: 'Admin',
  email: 'admin@grouphub.io',
  password: 'testtest',
  properties: {
    is_broker: true
  }

invitation = Invitation.create! \
  description: 'For GroupHub Admin'

# They're a system admin
Role.create! \
  user_id: admin.id,
  account_id: admin_account.id,
  name: 'admin'

# They're a broker
Role.create! \
  user_id: admin.id,
  account_id: first_account.id,
  name: 'broker',
  invitation_id: invitation.id

# Note that invitations only get an account ID once a role is created.
invitation.update_attributes! \
  account_id: first_account.id

# =====
# Alice
# =====

alice = User.create! \
  first_name: 'Alice',
  last_name: 'Doe',
  email: 'alice@first-account.com',
  password: 'testtest'

# She's a customer
Role.create! \
  user_id: alice.id,
  account_id: first_account.id,
  name: 'customer'

# ===
# Bob
# ===

bob = User.create! \
  first_name: 'Bob',
  last_name: 'Smith',
  email: 'bob@first-account.com',
  password: 'testtest'

# He's a customer
Role.create! \
  user_id: bob.id,
  account_id: first_account.id,
  name: 'customer'

# =====
# Garol
# =====

garol = User.create! \
  first_name: 'Garol',
  last_name: 'Groupadmin',
  email: 'garol@first-account.com',
  password: 'testtest'

# She's a group admin
Role.create! \
  user_id: garol.id,
  account_id: first_account.id,
  name: 'group_admin'

