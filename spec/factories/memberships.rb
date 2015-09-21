FactoryGirl.define do
  factory :membership do
    group { create(:group) }
    email { Faker::Internet.email }
    role_name { "customer" }

    after :create do |membership|
      user = create(:user, email: membership.email)
      membership.update(user: user)
    end
  end
end
