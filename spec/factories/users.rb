FactoryGirl.define do
  factory :user do
    email      { Faker::Internet.email }
    password   { "supersecret" }

    trait :admin do
      first_name 'GroupHub'
      last_name  'Admin'
      email      'admin@grouphub.io'
    end

    trait :broker do
      email      'barry@broker.com'
      first_name { Faker::Name.first_name }
      last_name  { Faker::Name.last_name }

      after :create do |user|
        account = create(:account, :broker)
        create(:role, :broker, user_id: user.id, account_id: account.id)
      end
    end
  end
end
