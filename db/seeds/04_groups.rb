account = Account.where(name: 'First Account').first

group = Group.create! \
  account_id: account.id,
  name: 'My Group'

alice = User.where(email: 'alice@first-account.com').first
bob = User.where(email: 'bob@first-account.com').first
benefit_plan = BenefitPlan.first

GroupBenefitPlan.create! \
  group_id: group.id,
  benefit_plan_id: benefit_plan.id

Membership.create! \
  group_id: group.id,
  user_id: alice.id,
  email: alice.email

Membership.create! \
  group_id: group.id,
  user_id: bob.id,
  email: bob.email

