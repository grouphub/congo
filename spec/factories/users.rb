FactoryGirl.define do
  factory :user do
    factory :admin_user do
      first_name 'GroupHub'
      last_name  'Admin'
      email      'admin@grouphub.io'
      password   'testtest'
    end

    factory :broker_user do
      first_name 'Barry'
      last_name  'Broker'
      email      'barry@broker.com'
      password   'barry'
    end
  end
end
