class AccountCarrier < ActiveRecord::Base
  belongs_to :account
  belongs_to :carrier

  has_many :benefit_plans

  def properties=(hash)
    self.properties_data = hash.to_json
  end

  def properties
    JSON.load(self.properties_data)
  end

  def simple_hash
    {
      id: self.id,
      name: self.name,
      account_id: self.account_id,
      account: self.account,
      carrier_id: self.carrier_id,
      carrier: self.carrier
    }
  end
end

