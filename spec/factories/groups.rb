FactoryGirl.define do
  group_properties = {
    name: 'My group',
    group_id: '1',
    tax_id: '123'
  }

  factory :group do
    account_id 1
<<<<<<< HEAD
    name  { Faker::Company.name }
    slug  { name.parameterize.underscore }
=======
    name 'Group test'
    slug 'group_test'
>>>>>>> 43b8c25ebc78f40533620f7803972260d964f35c
    is_enabled true
    description_markdown 'Some description'
    description_html 'Some description'
    properties_data group_properties
  end
end
