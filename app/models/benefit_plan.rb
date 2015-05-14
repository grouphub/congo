class BenefitPlan < ActiveRecord::Base
  include Sluggable
  include Propertied

  acts_as_paranoid

  has_many :group_benefit_plans
  has_many :applications
  has_many :attachments
  has_many :account_benefit_plans

  belongs_to :account
  belongs_to :carrier_account
  belongs_to :carrier
end

