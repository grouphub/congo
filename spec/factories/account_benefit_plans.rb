FactoryGirl.define do
  factory :account_benefit_plan do
    account         { create(:account) }
    carrier         { create(:carrier) }
    carrier_account { create(:carrier_account, account: account, carrier: carrier) }
    benefit_plan    { create(:benefit_plan, carrier: carrier, account: account) }
  end
end
