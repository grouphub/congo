first_account = Account.where(name: 'Top Tier Brokerage').first

# =====
# Users
# =====

# ID 8
sally = User.create! \
  first_name: 'Sally',
  last_name: 'Breadmaker',
  email: 'sally@bread.com',
  password: 'testtest'

# ID 9
sam = User.create! \
  first_name: 'Sam',
  last_name: 'Breadmaker',
  email: 'sam@bread.com',
  password: 'testtest'

# ID 10
kevin = User.create! \
  first_name: 'Kevin',
  last_name: 'Breadmaker',
  email: 'kevin@bread.com',
  password: 'testtest'

# ID 5
john = User.create! \
  first_name: 'John',
  last_name: 'Breadmaker',
  email: 'john@bread.com',
  password: 'testtest'

# =====
# Roles
# =====

# ID 9
sally_role = Role.create! \
  user_id: sally.id,
  account_id: first_account.id,
  name: 'customer'

# ID 10
sam_role = Role.create! \
  user_id: sam.id,
  account_id: first_account.id,
  name: 'customer'

# ID 11
kevin_role = Role.create! \
  user_id: kevin.id,
  account_id: first_account.id,
  name: 'customer'

# ID 5
john_role = Role.create! \
  user_id: john.id,
  account_id: first_account.id,
  name: 'group_admin'

# ======
# Groups
# ======

# ID 2
description_html = %[<h1 id="sally-s-bread-company">Sally&#39;s Bread Company</h1>\n<p>Sally&#39;s Bread Company offers a full range of benefits for all employees.  You can see a summary of benefits offered in the attachments section.  </p>\n<h2 id="benefits-offered-">Benefits Offered:</h2>\n<p>You can see a summary of benefits offered in the attachments section.</p>\n<h4 id="aetna-ppo">Aetna PPO</h4>\n<h4 id="the-guardian-life-insurance">The Guardian Life Insurance</h4>\n<h4 id="the-guardian-long-term-disability">The Guardian Long Term Disability</h4>\n<h4 id="transamerica-401k">TransAmerica 401k</h4>\n<h4 id="vsp-premier-vision">VSP Premier Vision</h4>\n<h4 id="delta-dental-platinum-plan">Delta Dental Platinum Plan</h4>]
description_markdown = "# Sally's Bread Company\nSally's Bread Company offers a full range of benefits for all employees.  You can see a summary of benefits offered in the attachments section.  \n\n##Benefits Offered:\nYou can see a summary of benefits offered in the attachments section.\n####Aetna PPO\n####The Guardian Life Insurance\n####The Guardian Long Term Disability\n####TransAmerica 401k\n####VSP Premier Vision\n####Delta Dental Platinum Plan"
sally_group = Group.create! \
  account_id: first_account.id,
  name: 'Sally\'s Bread Company',
  is_enabled: true,
  description_html: description_html,
  description_markdown: description_markdown,
  properties: {
    name: 'Sally\'s Bread Company',
    group_id: '234',
    tax_id: '345',
    description_html: description_html,
    description_markdown: description_markdown
  }

# ID 1
description_html = %[<h1 id="uber-tech-company">Uber Tech Company</h1>\n<p>Uber Tech Company offers a full range of benefits for all employees.  You can see a summary of benefits offered in the attachments section.  </p>\n<h2 id="benefits-offered-">Benefits Offered:</h2>\n<p>You can see a summary of benefits offered in the attachments section.</p>\n<h4 id="aetna-ppo">Aetna PPO</h4>\n<h4 id="the-guardian-life-insurance">The Guardian Life Insurance</h4>\n<h4 id="the-guardian-long-term-disability">The Guardian Long Term Disability</h4>\n<h4 id="transamerica-401k">TransAmerica 401k</h4>\n<h4 id="vsp-premier-vision">VSP Premier Vision</h4>\n<h4 id="delta-dental-platinum-plan">Delta Dental Platinum Plan</h4>]
description_markdown = "# Uber Tech Company\nUber Tech Company offers a full range of benefits for all employees.  You can see a summary of benefits offered in the attachments section.  \n\n##Benefits Offered:\nYou can see a summary of benefits offered in the attachments section.\n####Aetna PPO\n####The Guardian Life Insurance\n####The Guardian Long Term Disability\n####TransAmerica 401k\n####VSP Premier Vision\n####Delta Dental Platinum Plan"
uber_group = Group.create! \
  account_id: first_account.id,
  name: 'Uber Tech Company',
  is_enabled: true,
  description_html: description_html,
  description_markdown: description_markdown,
  properties: {
    name: 'Uber Tech Company',
    group_id: '234',
    tax_id: '345',
    description_html: description_html,
    description_markdown: description_markdown
  }

# ========
# Carriers
# ========

# ID 9
aetna_carrier = Carrier.where(name: 'Aetna').first

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

# ID 1
twenty_first_carrier = Carrier.where(name: '21st Century Insurance and Financial Services').first

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

# ID 299
kaiser_carrier = Carrier.where(name: 'Kaiser Permanente of Southern CA').first

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

# =============
# Benefit Plans
# =============

# ID 6
delta_dental_plan = BenefitPlan.create! \
  account_id: first_account.id,
  carrier_id: aetna_carrier.id,
  carrier_account_id: aetna_carrier_account.id,
  is_enabled: true,
  name: 'Delta Dental Platinum Plan',
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

delta_dental_account_plan = AccountBenefitPlan.create! \
  account_id: first_account.id,
  carrier_id: aetna_carrier.id,
  carrier_account_id: aetna_carrier_account.id,
  benefit_plan_id: delta_dental_plan.id,
  properties: {

  }

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
vsp_premier_plan = BenefitPlan.create! \
  account_id: first_account.id,
  carrier_id: twenty_first_carrier.id,
  carrier_account_id: twenty_first_carrier_account.id,
  is_enabled: true,
  name: 'VSP Premier Vision',
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

vsp_premier_account_plan = AccountBenefitPlan.create! \
  account_id: first_account.id,
  carrier_id: twenty_first_carrier.id,
  carrier_account_id: twenty_first_carrier_account.id,
  benefit_plan_id: vsp_premier_plan.id,
  properties: {

  }

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
the_guardian_life_plan = BenefitPlan.create! \
  account_id: first_account.id,
  carrier_id: twenty_first_carrier.id,
  carrier_account_id: twenty_first_carrier_account.id,
  is_enabled: true,
  name: 'The Guardian Life Insurance',
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

the_guardian_life_account_plan = AccountBenefitPlan.create! \
  account_id: first_account.id,
  carrier_id: twenty_first_carrier.id,
  carrier_account_id: twenty_first_carrier_account.id,
  benefit_plan_id: the_guardian_life_plan.id,
  properties: {

  }

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
the_guardian_long_plan = BenefitPlan.create! \
  account_id: first_account.id,
  carrier_id: twenty_first_carrier.id,
  carrier_account_id: twenty_first_carrier_account.id,
  is_enabled: true,
  name: 'The Guardian Long Term Disability',
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

the_guardian_long_account_plan = AccountBenefitPlan.create! \
  account_id: first_account.id,
  carrier_id: twenty_first_carrier.id,
  carrier_account_id: twenty_first_carrier_account.id,
  benefit_plan_id: the_guardian_long_plan.id,
  properties: {

  }

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
transamerica_plan = BenefitPlan.create! \
  account_id: first_account.id,
  carrier_id: twenty_first_carrier.id,
  carrier_account_id: twenty_first_carrier_account.id,
  is_enabled: true,
  name: 'TransAmerica 401k',
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

transamerica_account_plan = AccountBenefitPlan.create! \
  account_id: first_account.id,
  carrier_id: twenty_first_carrier.id,
  carrier_account_id: twenty_first_carrier_account.id,
  benefit_plan_id: transamerica_plan.id,
  properties: {

  }

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
aetna_plan = BenefitPlan.create! \
  account_id: first_account.id,
  carrier_id: aetna_carrier.id,
  carrier_account_id: aetna_carrier_account.id,
  is_enabled: true,
  name: 'Aetna PPO',
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

aetna_account_plan = AccountBenefitPlan.create! \
  account_id: first_account.id,
  carrier_id: twenty_first_carrier.id,
  carrier_account_id: twenty_first_carrier_account.id,
  benefit_plan_id: aetna_plan.id,
  properties: {

  }

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
kaiser_plan = BenefitPlan.create! \
  account_id: first_account.id,
  carrier_id: twenty_first_carrier.id,
  carrier_account_id: twenty_first_carrier_account.id,
  is_enabled: true,
  name: 'Kaiser Silver Grandfather',
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

kaiser_account_plan = AccountBenefitPlan.create! \
  account_id: first_account.id,
  carrier_id: twenty_first_carrier.id,
  carrier_account_id: twenty_first_carrier_account.id,
  benefit_plan_id: kaiser_plan.id,
  properties: {

  }

# ===========
# Memberships
# ===========

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

