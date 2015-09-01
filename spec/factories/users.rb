FactoryGirl.define do
  factory :user do
    factory :admin_user do
      first_name 'GroupHub'
      last_name  'Admin'
      email      'admin@grouphub.io'
      password   'testtest'
    end
  end
end
