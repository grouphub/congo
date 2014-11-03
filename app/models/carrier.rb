class Carrier < ActiveRecord::Base
  before_save :add_slug

  has_many :products
  has_many :account_carriers

  def add_slug
    self.slug = Sluggerizer.sluggerize(self.name) if self.name
  end

  def properties=(hash)
    self.properties_data = hash.to_json
  end

  def properties
    JSON.load(self.properties_data)
  end
end

