FactoryGirl.define do
  factory :role do
    user_id    1
    account_id 1

    factory :admin_role do
      name       'admin'
    end
  end
end
