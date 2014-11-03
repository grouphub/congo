class BenefitPlan < ActiveRecord::Base
  include Sluggable
  include Proper

  has_many :group_benefit_plans
  has_many :applications

  belongs_to :account
  belongs_to :account_carrier

  def simple_hash
    {
      name: self.name,
      slug: self.slug,
      account_id: self.account_id,
      account_carrier: self.account_carrier.simple_hash
    }
  end
end

