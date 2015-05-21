

first_account = Account.where(name: 'Top Tier Brokerage').first

puts 'Destroying existing demo groups, attachments, memberships, and group benefit plans.'

sally_group = Group.where(name: 'Sally\'s Bread Company').first
uber_group = Group.where(name: 'Uber Tech Company').first

if sally_group
  Attachment.where(group_id: sally_group.id).destroy_all
  Membership.where(group_id: sally_group.id).destroy_all
  GroupBenefitPlan.where(group_id: sally_group.id).destroy_all
end

if uber_group
  Attachment.where(group_id: uber_group.id).destroy_all
  Membership.where(group_id: uber_group.id).destroy_all
  GroupBenefitPlan.where(group_id: uber_group.id).destroy_all
end

Group.where(name: 'Sally\'s Bread Company').destroy_all
Group.where(name: 'Uber Tech Company').destroy_all

example_description_markdown = File.read("#{Rails.root}/spec/data/description.html")
example_description_html = Kramdown::Document.new(example_description_markdown).to_html

# =====
# Users
# =====

puts 'Creating users.'

# ID 8
sally = User.where(email: 'sally@bread.com').first
unless sally
  puts 'User "sally@bread.com" does not yet exist. Creating.'

  sally = User.create! \
    first_name: 'Sally',
    last_name: 'Breadmaker',
    email: 'sally@bread.com',
    password: 'testtest'
end

# ID 9
sam = User.where(email: 'sam@bread.com').first
unless sam
  puts 'User "sam@bread.com" does not yet exist. Creating.'

  sam = User.create! \
    first_name: 'Sam',
    last_name: 'Breadmaker',
    email: 'sam@bread.com',
    password: 'testtest'
end

# ID 10
kevin = User.where(email: 'kevin@bread.com').first
unless kevin
  puts 'User "kevin@bread.com" does not yet exist. Creating.'

  kevin = User.create! \
    first_name: 'Kevin',
    last_name: 'Breadmaker',
    email: 'kevin@bread.com',
    password: 'testtest'
end

# ID 5
john = User.where(email: 'john@bread.com').first
unless john
  puts 'User "john@bread.com" does not yet exist. Creating.'

  john = User.create! \
    first_name: 'John',
    last_name: 'Breadmaker',
    email: 'john@bread.com',
    password: 'testtest'
end

# =====
# Roles
# =====

puts 'Creating roles.'

# ID 9
sally_role = Role
  .where(
    user_id: sally.id,
    account_id: first_account.id,
    name: 'customer'
  )
  .first

unless sally_role
  puts 'Customer role for "sally@bread.com" does not yet exist. Creating.'

  sally_role = Role.create! \
    user_id: sally.id,
    account_id: first_account.id,
    name: 'customer'
end

# ID 10
sam_role = Role
  .where(
    user_id: sam.id,
    account_id: first_account.id,
    name: 'customer'
  )
  .first

unless sam_role
  puts 'Customer role for "sam@bread.com" does not yet exist. Creating.'

  sam_role = Role.create! \
    user_id: sam.id,
    account_id: first_account.id,
    name: 'customer'
end

# ID 11
kevin_role = Role
  .where(
    user_id: kevin.id,
    account_id: first_account.id,
    name: 'customer'
  )
  .first

unless kevin_role
  puts 'Customer role for "kevin@bread.com" does not yet exist. Creating.'

  kevin_role = Role.create! \
    user_id: kevin.id,
    account_id: first_account.id,
    name: 'customer'
end

# ID 5
john_role = Role
  .where(
    user_id: john.id,
    account_id: first_account.id,
    name: 'group_admin'
  )
  .first

unless john_role
  puts 'Customer role for "john@bread.com" does not yet exist. Creating.'

  john_role = Role.create! \
    user_id: john.id,
    account_id: first_account.id,
    name: 'group_admin'
end

# ======
# Groups
# ======

puts 'Creating test groups.'

# ID 2
sally_group = Group.create! \
  account_id: first_account.id,
  name: 'Sally\'s Bread Company',
  is_enabled: true,
  description_html: example_description_html,
  description_markdown: example_description_markdown,
  properties: {
    name: 'Sally\'s Bread Company',
    group_id: '234',
    tax_id: '345',
    description_html: example_description_html,
    description_markdown: example_description_markdown
  }

# ID 1
uber_group = Group.create! \
  account_id: first_account.id,
  name: 'Uber Tech Company',
  is_enabled: true,
  description_html: example_description_html,
  description_markdown: example_description_markdown,
  properties: {
    name: 'Uber Tech Company',
    group_id: '234',
    tax_id: '345',
    description_html: example_description_html,
    description_markdown: example_description_markdown
  }

# ========
# Carriers
# ========

puts 'Creating carriers and carrier accounts.'

# ID 9
aetna_carrier = Carrier.where(name: 'Aetna').first

aetna_carrier_account = CarrierAccount
  .where(
    account_id: first_account.id,
    carrier_id: aetna_carrier.id
  )
  .first

unless aetna_carrier_account
  puts '"Aetna" carrier account does not yet exist. Creating.'

  aetna_carrier_account = CarrierAccount.create! \
    account_id: first_account.id,
    carrier_id: aetna_carrier.id,
    name: 'Aetna',
    properties: {
      name: 'Aetna',
      carrier_slug: 'aetna',
      broker_number: '234',
      brokerage_name: 'Top Tier Brokerage',
      tax_id: '345',
      account_type: 'broker'
    }
end

# ID 1
twenty_first_carrier = Carrier.where(name: '21st Century Insurance and Financial Services').first

twenty_first_carrier_account = CarrierAccount
  .where(
    account_id: first_account.id,
    carrier_id: twenty_first_carrier.id
  )
  .first

unless twenty_first_carrier_account
  puts '"21st Century Insurance and Financial Services" carrier account does not yet exist. Creating.'

  twenty_first_carrier_account = CarrierAccount.create! \
    account_id: first_account.id,
    carrier_id: twenty_first_carrier.id,
    name: '21st Century Insurance and Financial Services',
    properties: {
      name: '21st Century Insurance and Financial Services',
      carrier_slug: '21st_century_insurance_and_financial_services',
      broker_number: '234',
      brokerage_name: 'Top Tier Brokerage',
      tax_id: '345',
      account_type: 'broker'
    }
end

# ID 299
kaiser_carrier = Carrier.where(name: 'Kaiser Permanente of Southern CA').first

kaiser_carrier_account = CarrierAccount
  .where(
    account_id: first_account.id,
    carrier_id: twenty_first_carrier.id
  )
  .first

unless kaiser_carrier_account
  puts '"Kaiser Permanente of Southern CA" carrier account does not yet exist. Creating.'

  kaiser_carrier_account = CarrierAccount.create! \
    account_id: first_account.id,
    carrier_id: twenty_first_carrier.id,
    name: 'Kaiser Permanente of Southern CA',
    properties: {
      name: 'Kaiser Permanente of Southern CA',
      carrier_slug: 'kaiser_permanente_of_southern_ca',
      broker_number: '234',
      brokerage_name: 'Top Tier Brokerage',
      tax_id: '345',
      account_type: 'broker'
    }
end

# =============
# Benefit Plans
# =============

puts 'Creating benefit plans, account benefit plans, and group benefit plans.'

# ID 6
delta_dental_plan = BenefitPlan
  .where(
    account_id: first_account.id,
    carrier_id: aetna_carrier.id,
    name: 'Delta Dental Platinum Plan'
  )
  .first

unless delta_dental_plan
  puts '"Delta Dental Platinum" benefit plan does not yet exist. Creating.'

  delta_dental_plan = BenefitPlan.create! \
    account_id: first_account.id,
    carrier_id: aetna_carrier.id,
    carrier_account_id: aetna_carrier_account.id,
    name: 'Delta Dental Platinum Plan',
    is_enabled: true,
    description_html: '',
    description_markdown: '',
    properties: {
      name: 'Delta Dental Platinum Plan',
      description_html: '',
      description_markdown: '',
      plan_type: 'foo',
      exchange_plan: 'bar',
      small_group: 'baz',
      group_id: '235'
    }
end

delta_dental_account_plan = AccountBenefitPlan
  .where(
    account_id: first_account.id,
    carrier_id: aetna_carrier.id,
    benefit_plan_id: delta_dental_plan.id
  )
  .first

unless delta_dental_account_plan
  puts '"Delta Dental Platinum" account benefit plan does not yet exist. Creating.'

  delta_dental_account_plan = AccountBenefitPlan.create! \
    account_id: first_account.id,
    carrier_id: aetna_carrier.id,
    benefit_plan_id: delta_dental_plan.id,
    carrier_account_id: aetna_carrier_account.id,
    properties: {

    }
end

GroupBenefitPlan.create! \
  account_id: first_account.id,
  group_id: uber_group.id,
  benefit_plan_id: delta_dental_plan.id,
  properties: {
    broker_id: '4441122'
  }

GroupBenefitPlan.create! \
  account_id: first_account.id,
  group_id: sally_group.id,
  benefit_plan_id: delta_dental_plan.id,
  properties: {
    broker_id: '12345'
  }

# ID 7
vsp_premier_plan = BenefitPlan
  .where(
    account_id: first_account.id,
    carrier_id: twenty_first_carrier.id,
    carrier_account_id: twenty_first_carrier_account.id,
    name: 'VSP Premier Vision',
  )
  .first

unless vsp_premier_plan
  puts '"VSP Premier Vision" benefit plan does not yet exist. Creating.'

  vsp_premier_plan = BenefitPlan.create! \
    account_id: first_account.id,
    carrier_id: twenty_first_carrier.id,
    carrier_account_id: twenty_first_carrier_account.id,
    name: 'VSP Premier Vision',
    is_enabled: true,
    description_html: '',
    description_markdown: '',
    properties: {
      name: 'VSP Premier Vision',
      description_html: '',
      description_markdown: '',
      plan_type: 'foo',
      exchange_plan: 'bar',
      small_group: 'baz',
      group_id: '235'
    }
end

vsp_premier_account_plan = AccountBenefitPlan
  .where(
    account_id: first_account.id,
    carrier_id: twenty_first_carrier.id,
    benefit_plan_id: vsp_premier_plan.id
  )
  .first

unless vsp_premier_account_plan
  puts '"VSP Premier Vision" account benefit plan does not yet exist. Creating.'

  vsp_premier_account_plan = AccountBenefitPlan.create! \
    account_id: first_account.id,
    carrier_id: twenty_first_carrier.id,
    benefit_plan_id: vsp_premier_plan.id,
    carrier_account_id: twenty_first_carrier_account.id,
    properties: {

    }
end

GroupBenefitPlan.create! \
  account_id: first_account.id,
  group_id: uber_group.id,
  benefit_plan_id: vsp_premier_plan.id,
  properties: {
    broker_id: '4441122'
  }

GroupBenefitPlan.create! \
  account_id: first_account.id,
  group_id: sally_group.id,
  benefit_plan_id: vsp_premier_plan.id,
  properties: {
    broker_id: '12345'
  }

# ID 3
the_guardian_life_plan = BenefitPlan
  .where(
    account_id: first_account.id,
    carrier_id: twenty_first_carrier.id,
    name: 'The Guardian Life Insurance'
  )
  .first

unless the_guardian_life_plan
  puts '"The Guardian Life Insurance" benefit plan does not yet exist. Creating.'

  the_guardian_life_plan = BenefitPlan.create! \
    account_id: first_account.id,
    carrier_id: twenty_first_carrier.id,
    carrier_account_id: twenty_first_carrier_account.id,
    name: 'The Guardian Life Insurance',
    is_enabled: true,
    description_html: '',
    description_markdown: '',
    properties: {
      name: 'The Guardian Life Insurance',
      description_html: '',
      description_markdown: '',
      plan_type: 'foo',
      exchange_plan: 'bar',
      small_group: 'baz',
      group_id: '235'
    }
end

the_guardian_life_account_plan = AccountBenefitPlan
  .where(
    account_id: first_account.id,
    carrier_id: twenty_first_carrier.id,
    benefit_plan_id: the_guardian_life_plan.id
  )
  .first

unless the_guardian_life_account_plan
  puts '"The Guardian Life Insurance" account benefit plan does not yet exist. Creating.'

  the_guardian_life_account_plan = AccountBenefitPlan.create! \
    account_id: first_account.id,
    carrier_id: twenty_first_carrier.id,
    benefit_plan_id: the_guardian_life_plan.id,
    carrier_account_id: twenty_first_carrier_account.id,
    properties: {

    }
end

GroupBenefitPlan.create! \
  account_id: first_account.id,
  group_id: uber_group.id,
  benefit_plan_id: the_guardian_life_plan.id,
  properties: {
    broker_id: '4441122'
  }

GroupBenefitPlan.create! \
  account_id: first_account.id,
  group_id: sally_group.id,
  benefit_plan_id: the_guardian_life_plan.id,
  properties: {
    broker_id: '12345'
  }

# ID 4
the_guardian_long_plan = BenefitPlan
  .where(
    account_id: first_account.id,
    carrier_id: twenty_first_carrier.id,
    carrier_account_id: twenty_first_carrier_account.id,
    name: 'The Guardian Long Term Disability'
  )
  .first

unless the_guardian_long_plan
  puts '"The Guardian Long Term Disability" benefit plan does not yet exist. Creating.'

  the_guardian_long_plan = BenefitPlan.create! \
    account_id: first_account.id,
    carrier_id: twenty_first_carrier.id,
    carrier_account_id: twenty_first_carrier_account.id,
    name: 'The Guardian Long Term Disability',
    is_enabled: true,
    description_html: '',
    description_markdown: '',
    properties: {
      name: 'The Guardian Long Term Disability',
      description_html: '',
      description_markdown: '',
      plan_type: 'foo',
      exchange_plan: 'bar',
      small_group: 'baz',
      group_id: '235'
    }
end

the_guardian_long_account_plan = AccountBenefitPlan
  .where(
    account_id: first_account.id,
    carrier_id: twenty_first_carrier.id,
    benefit_plan_id: the_guardian_long_plan.id
  )
  .first

unless the_guardian_long_account_plan
  puts '"The Guardian Long Term Disability" account benefit plan does not yet exist. Creating.'

  the_guardian_long_account_plan = AccountBenefitPlan.create! \
    account_id: first_account.id,
    carrier_id: twenty_first_carrier.id,
    benefit_plan_id: the_guardian_long_plan.id,
    carrier_account_id: twenty_first_carrier_account.id,
    properties: {

    }
end

GroupBenefitPlan.create! \
  account_id: first_account.id,
  group_id: uber_group.id,
  benefit_plan_id: the_guardian_long_plan.id,
  properties: {
    broker_id: '4441122'
  }

GroupBenefitPlan.create! \
  account_id: first_account.id,
  group_id: sally_group.id,
  benefit_plan_id: the_guardian_long_plan.id,
  properties: {
    broker_id: '12345'
  }

# ID 5
transamerica_plan = BenefitPlan
  .where(
    account_id: first_account.id,
    carrier_id: twenty_first_carrier.id,
    name: 'TransAmerica 401k'
  )
  .first

unless transamerica_plan
  puts '"TransAmerica 401k" benefit plan does not yet exist. Creating.'

  transamerica_plan = BenefitPlan.create! \
    account_id: first_account.id,
    carrier_id: twenty_first_carrier.id,
    carrier_account_id: twenty_first_carrier_account.id,
    name: 'TransAmerica 401k',
    is_enabled: true,
    description_html: '',
    description_markdown: '',
    properties: {
      name: 'TransAmerica 401k',
      description_html: '',
      description_markdown: '',
      plan_type: 'foo',
      exchange_plan: 'bar',
      small_group: 'baz',
      group_id: '235'
    }
end

transamerica_account_plan = AccountBenefitPlan
  .where(
    account_id: first_account.id,
    carrier_id: twenty_first_carrier.id,
    benefit_plan_id: transamerica_plan.id
  )
  .first

unless transamerica_account_plan
  puts '"TransAmerica 401k" account benefit plan does not yet exist. Creating.'

  transamerica_account_plan = AccountBenefitPlan.create! \
    account_id: first_account.id,
    carrier_id: twenty_first_carrier.id,
    benefit_plan_id: transamerica_plan.id,
    carrier_account_id: twenty_first_carrier_account.id,
    properties: {

    }
end

GroupBenefitPlan.create! \
  account_id: first_account.id,
  group_id: uber_group.id,
  benefit_plan_id: transamerica_plan.id,
  properties: {
    broker_id: '4441122'
  }

GroupBenefitPlan.create! \
  account_id: first_account.id,
  group_id: sally_group.id,
  benefit_plan_id: transamerica_plan.id,
  properties: {
    broker_id: '12345'
  }

# ID 8
aetna_plan = BenefitPlan
  .where(
    account_id: first_account.id,
    carrier_id: twenty_first_carrier.id,
    name: 'Aetna PPO'
  )
  .first

unless aetna_plan
  puts '"Aetna PPO" benefit plan does not yet exist. Creating.'

  aetna_plan = BenefitPlan.create! \
    account_id: first_account.id,
    carrier_id: twenty_first_carrier.id,
    carrier_account_id: twenty_first_carrier_account.id,
    name: 'Aetna PPO',
    is_enabled: true,
    description_html: '',
    description_markdown: '',
    properties: {
      name: 'Aetna PPO',
      description_html: '',
      description_markdown: '',
      plan_type: 'foo',
      exchange_plan: 'bar',
      small_group: 'baz',
      group_id: '235'
    }
end

aetna_account_plan = AccountBenefitPlan
  .where(
    account_id: first_account.id,
    carrier_id: twenty_first_carrier.id,
    benefit_plan_id: aetna_plan.id
  )
  .first

unless aetna_account_plan
  puts '"Aetna PPO" account benefit plan does not yet exist. Creating.'

  aetna_account_plan = AccountBenefitPlan.create! \
    account_id: first_account.id,
    carrier_id: twenty_first_carrier.id,
    benefit_plan_id: aetna_plan.id,
    carrier_account_id: twenty_first_carrier_account.id,
    properties: {

    }
end

GroupBenefitPlan.create! \
  account_id: first_account.id,
  group_id: uber_group.id,
  benefit_plan_id: aetna_plan.id,
  properties: {
    broker_id: '4441122'
  }

GroupBenefitPlan.create! \
  account_id: first_account.id,
  group_id: sally_group.id,
  benefit_plan_id: aetna_plan.id,
  properties: {
    broker_id: '12345'
  }

# ID 9
kaiser_plan = BenefitPlan
  .where(
    account_id: first_account.id,
    carrier_id: twenty_first_carrier.id,
    name: 'Kaiser Silver Grandfather'
  )
  .first

unless kaiser_plan
  puts '"Kaiser Silver Grandfather" benefit plan does not yet exist. Creating.'

  kaiser_plan = BenefitPlan.create! \
    account_id: first_account.id,
    carrier_id: twenty_first_carrier.id,
    carrier_account_id: twenty_first_carrier_account.id,
    name: 'Kaiser Silver Grandfather',
    is_enabled: true,
    description_html: '',
    description_markdown: '',
    properties: {
      name: 'Kaiser Silver Grandfather',
      description_html: '',
      description_markdown: '',
      plan_type: 'foo',
      exchange_plan: 'bar',
      small_group: 'baz',
      group_id: '235'
    }
end

kaiser_account_plan = AccountBenefitPlan
  .where(
    account_id: first_account.id,
    carrier_id: twenty_first_carrier.id,
    benefit_plan_id: kaiser_plan.id,
  )
  .first

unless kaiser_account_plan
  puts '"Kaiser Silver Grandfather" account benefit plan does not yet exist. Creating.'

  kaiser_account_plan = AccountBenefitPlan.create! \
    account_id: first_account.id,
    carrier_id: twenty_first_carrier.id,
    benefit_plan_id: kaiser_plan.id,
    carrier_account_id: twenty_first_carrier_account.id,
    properties: {

    }
end

# ===========
# Memberships
# ===========

puts 'Creating memberships.'

Membership.create! \
  account_id: first_account.id,
  group_id: sally_group.id,
  user_id: john.id,
  role_id: john.roles.first.id,
  email: john.email,
  role_name: 'customer'

Membership.create! \
  account_id: first_account.id,
  group_id: sally_group.id,
  user_id: nil,
  role_id: nil,
  email: 'roger@bread.com',
  role_name: 'customer'

Membership.create! \
  account_id: first_account.id,
  group_id: sally_group.id,
  user_id: sally.id,
  role_id: sally.roles.first.id,
  email: sally.email,
  role_name: 'customer'

Membership.create! \
  account_id: first_account.id,
  group_id: sally_group.id,
  user_id: sam.id,
  role_id: sam.roles.first.id,
  email: sam.email,
  role_name: 'customer'

Membership.create! \
  account_id: first_account.id,
  group_id: sally_group.id,
  user_id: kevin.id,
  role_id: kevin.roles.first.id,
  email: kevin.email,
  role_name: 'customer'

Membership.create! \
  account_id: first_account.id,
  group_id: sally_group.id,
  user_id: nil,
  role_id: nil,
  email: 'joe@bread.com',
  role_name: 'customer'

Membership.create! \
  account_id: first_account.id,
  group_id: sally_group.id,
  user_id: nil,
  role_id: nil,
  email: 'jenny@bread.com',
  role_name: 'group_admin'

Membership.create! \
  account_id: first_account.id,
  group_id: sally_group.id,
  user_id: nil,
  role_id: nil,
  email: 'jim@bread.com',
  role_name: 'customer'

Membership.create! \
  account_id: first_account.id,
  group_id: sally_group.id,
  user_id: nil,
  role_id: nil,
  email: 'allen@bread.com',
  role_name: 'customer'

Membership.create! \
  account_id: first_account.id,
  group_id: sally_group.id,
  user_id: nil,
  role_id: nil,
  email: 'allen@uber.com',
  role_name: 'customer'

# ===========
# Attachments
# ===========

puts 'Creating attachments.'

[sally_group, uber_group].each do |group|
  title = 'Summary of Benefits'
  description = 'Aetna Summary of Benefits'
  name = ThirtySix.generate
  tempfile = File.open("#{Rails.root}/spec/data/aetna-summary.pdf")
  content_type = 'application/pdf'
  url = S3.public_url(name)

  if Rails.env.development?
    upload_to_fakes3(name, tempfile, content_type)
  elsif Rails.env.production?
    S3.store(name, tempfile, content_type)
  end

  Attachment.create! \
    account_id: group.account_id,
    group_id: group.id,
    title: title,
    filename: name,
    description: description,
    content_type: content_type,
    url: url
end

