FactoryGirl.define do
<<<<<<< HEAD
  factory :account do
    trait :admin do
      name       'Admin'
      tagline    'GroupHub administrative account'
      plan_name  'admin'
      properties { { name: 'Admin',
                     tagline: 'GroupHub administrative account',
                     plan_name: 'admin' } }
    end

    trait :broker do
      name       'First Account'
      tagline    '#1 Account'
      plan_name  'basic'
      properties { { name: 'First Account',
                     tagline: '#1 Account',
                     plan_name: 'basic' } }
=======
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
>>>>>>> 43b8c25ebc78f40533620f7803972260d964f35c
    end
  end
end
