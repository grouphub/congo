FactoryGirl.define do
  factory :membership do
    group { create(:group) }
    email { Faker::Internet.email }
    role_name { "customer" }

    trait :with_user do
      user { create(:user, email: email) }
    end
  end
end
