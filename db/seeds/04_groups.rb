account = Account.where(name: 'First Account').first

group = Group.create! \
  account_id: account.id,
  name: 'My Group',
  is_enabled: true,
  description_html: "<h1>My Group</h1>\n<p>An example group.</p>",
  description_markdown: "# My Group\n\nAn example group.",
  properties: {
    description_html: "<h1>My Group</h1>\n<p>An example group.</p>",
    description_markdown: "# My Group\n\nAn example group."
  }

alice = User.where(email: 'alice@first-account.com').first
bob = User.where(email: 'bob@first-account.com').first
garol = User.where(email: 'garol@first-account.com').first
benefit_plan = BenefitPlan.first

GroupBenefitPlan.create! \
  group_id: group.id,
  benefit_plan_id: benefit_plan.id

Membership.create! \
  group_id: group.id,
  user_id: alice.id,
  role_id: alice.roles.first.id,
  email: alice.email

Membership.create! \
  group_id: group.id,
  user_id: bob.id,
  role_id: bob.roles.first.id,
  email: bob.email

Membership.create! \
  group_id: group.id,
  user_id: garol.id,
  role_id: garol.roles.first.id,
  email: garol.email

