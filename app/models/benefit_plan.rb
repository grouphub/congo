class BenefitPlan < ActiveRecord::Base
  include Sluggable
  include Proper

  has_many :group_benefit_plans
  has_many :applications

  belongs_to :account
  belongs_to :account_carrier
end

