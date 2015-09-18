FactoryGirl.define do
  factory :carrier do
    name { Faker::Company.name }
    slug { name.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '') }
  end
end
