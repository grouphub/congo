FactoryGirl.define do
  admin_properties = {
    name: 'Admin',
    tagline: 'GroupHub administrative account',
    plan_name: 'admin'
  }

  broker_properties = {
    name: 'First Account',
    tagline: '#1 Account',
    plan_name: 'basic'
  }

  factory :account do
    factory :admin_account do
      name       'Admin'
      tagline    'GroupHub administrative account'
      plan_name  'admin'
      properties admin_properties
    end

    factory :broker_account do
      name       'First Account'
      tagline    '#1 Account'
      plan_name  'basic'
      properties broker_properties
    end
  end
end
