FactoryGirl.define do
  factory :user do
<<<<<<< HEAD
    email      { Faker::Internet.email }
    password   { "supersecret" }

    trait :admin do
      first_name 'GroupHub'
      last_name  'Admin'
      email      'admin@grouphub.io'

      after :create do |user|
        account = create(:account, :admin)
        create(:role, :admin, user_id: user.id, account_id: account.id)
      end
    end

    trait :broker do
      email      'barry@broker.com'
      first_name { Faker::Name.first_name }
      last_name  { Faker::Name.last_name }

      after :create do |user|
        account = create(:account, :broker, slug: Faker::Lorem.word)
        create(:role, :broker, user_id: user.id, account_id: account.id)
      end
    end

    trait :customer do
      first_name { Faker::Name.first_name }
      last_name  { Faker::Name.last_name }
      email      { Faker::Internet.email }
=======
    factory :admin_user do
      first_name 'GroupHub'
      last_name  'Admin'
      email      'admin@grouphub.io'
      password   'supersecret'
    end

    factory :broker_user do
      first_name 'Barry'
      last_name  'Broker'
      email      'barry@broker.com'
      password   'supersecret'
>>>>>>> 43b8c25ebc78f40533620f7803972260d964f35c
    end
  end
end
