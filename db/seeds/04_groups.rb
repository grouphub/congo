first_account = Account.where(name: 'Top Tier Brokerage').first
second_account = Account.where(name: 'Second Account').first

# =============
# First Account
# =============

group = Group.create! \
  account_id: first_account.id,
  name: 'My Group',
  is_enabled: true,
  description_html: "<h1>My Group</h1>\n<p>An example group.</p>",
  description_markdown: "# My Group\n\nAn example group.",
  properties: {
    name: 'My Group',
    group_id: '234',
    tax_id: '345',
    description_html: "<h1>My Group</h1>\n<p>An example group.</p>",
    description_markdown: "# My Group\n\nAn example group."
  }

alice = User.where(email: 'alice@first-account.com').first
bob = User.where(email: 'bob@first-account.com').first
garol = User.where(email: 'garol@first-account.com').first
benefit_plan = BenefitPlan.where(account_id: first_account.id).first

GroupBenefitPlan.create! \
  account_id: first_account.id,
  group_id: group.id,
  benefit_plan_id: benefit_plan.id

Membership.create! \
  account_id: first_account.id,
  group_id: group.id,
  user_id: alice.id,
  role_id: alice.roles.first.id,
  email: alice.email,
  role_name: 'customer'

Membership.create! \
  account_id: first_account.id,
  group_id: group.id,
  user_id: bob.id,
  role_id: bob.roles.first.id,
  email: bob.email,
  role_name: 'customer'

Membership.create! \
  account_id: first_account.id,
  group_id: group.id,
  user_id: garol.id,
  role_id: garol.roles.first.id,
  email: garol.email,
  role_name: 'group_admin'

# ==============
# Second Account
# ==============

group = Group.create! \
  account_id: second_account.id,
  name: 'Second My Group',
  is_enabled: true,
  description_html: "<h1>My Group</h1>\n<p>An example group.</p>",
  description_markdown: "# My Group\n\nAn example group.",
  properties: {
    name: 'Second My Group',
    group_id: '234',
    tax_id: '345',
    description_html: "<h1>My Group</h1>\n<p>An example group.</p>",
    description_markdown: "# My Group\n\nAn example group."
  }

benefit_plan = BenefitPlan.where(account_id: second_account.id).first

GroupBenefitPlan.create! \
  account_id: first_account.id,
  group_id: group.id,
  benefit_plan_id: benefit_plan.id

