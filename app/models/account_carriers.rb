class AccountCarriers < ActiveRecord::Base
  belongs_to :accounts
  belongs_to :carriers

  def properties=(hash)
    self.properties_data = hash.to_json
  end

  def properties
    JSON.load(self.properties_data)
  end
end

