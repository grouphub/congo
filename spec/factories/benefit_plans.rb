FactoryGirl.define do
  factory :benefit_plan do
    account { create(:account) }
    carrier { create(:carrier) }
    carrier_account { create(:carrier_account, account: account, carrier: carrier) }
    name { "Best Health Insurance PPO" }
    slug { "best_health_insurance_ppo" }
    is_enabled { true }
    description_markdown { "# Best Health Insurance PPO\n\nAn example plan." }
    description_html { "<h1>Best Health Insurance PPO</h1>\n<p>An example plan.</p>" }
  end
end
