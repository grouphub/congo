FactoryGirl.define do
  group_properties = {
    name: 'My group',
    group_id: '1',
    tax_id: '123'
  }

  factory :group do
    account_id 1
    name 'Group test'
    slug 'group_test'
    is_enabled true
    description_markdown 'Some description'
    description_html 'Some description'
    properties_data group_properties
  end
end
