FactoryGirl.define do
  factory :carrier_account do
    carrier { create(:carrier) }
    account { create(:account) }
    name { "#{account.name} - #{carrier.name}" }
  end
end
