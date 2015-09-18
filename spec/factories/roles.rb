FactoryGirl.define do
  factory :role do
    user_id    1
    account_id 1
    name 'some_role'

    trait :admin do
      name 'admin'
    end

    trait :broker do
      name 'broker'
    end
  end
end
