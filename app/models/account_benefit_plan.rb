class AccountBenefitPlan < ActiveRecord::Base
  include Propertied

  acts_as_paranoid

  belongs_to :account
  belongs_to :carrier
  belongs_to :carrier_account
  belongs_to :benefit_plan

  delegate :name, to: :benefit_plan
end
