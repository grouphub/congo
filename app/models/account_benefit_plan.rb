class AccountBenefitPlan < ActiveRecord::Base
  include Propertied

  belongs_to :account
  belongs_to :carrier
  belongs_to :carrier_account
  belongs_to :benefit_plan
end
