FactoryGirl.define do
  properties_data = {
    name: 'Admin',
    tagline: 'GroupHub administrative account',
    plan_name: 'admin'
  }

  factory :account do
    factory :admin_account do
      name       'Admin'
      tagline    'GroupHub administrative account'
      plan_name  'admin'
      properties properties_data
    end
  end
end
