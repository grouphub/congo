FactoryGirl.define do
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
    end
  end
end
