class BenefitPlan < ActiveRecord::Base
  include Sluggable
  include Propertied

  has_many :group_benefit_plans
  has_many :applications
  has_many :attachments

  belongs_to :account
  belongs_to :carrier_account
end

