class BenefitPlan < ActiveRecord::Base
  has_many :group_benefit_plans
  has_many :applications

  belongs_to :account
  belongs_to :account_carrier

  before_save :add_slug

  def add_slug
    self.slug = Sluggerizer.sluggerize(self.name)
  end

  def properties=(hash)
    self.properties_data = hash.to_json
  end

  def properties
    JSON.load(self.properties_data)
  end

  def simple_hash
    {
      name: self.name,
      slug: self.slug,
      account_id: self.account_id,
      account_carrier: self.account_carrier.simple_hash
    }
  end
end

