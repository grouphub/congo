FactoryGirl.define do
  factory :role do
    user_id    1
    account_id 1
<<<<<<< HEAD
    name 'some_role'

    trait :admin do
      name 'admin'
    end

    trait :broker do
=======

    factory :admin_role do
      name 'admin'
    end

    factory :broker_role do
>>>>>>> 43b8c25ebc78f40533620f7803972260d964f35c
      name 'broker'
    end
  end
end
