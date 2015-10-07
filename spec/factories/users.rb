FactoryGirl.define do
  factory :user do
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
    end
  end
end
