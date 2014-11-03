class Product < ActiveRecord::Base
  has_many :group_products
  has_many :applications

  belongs_to :account
  belongs_to :account_carrier

  before_save :add_slug

  def add_slug
    self.slug = Sluggerizer.sluggerize(self.name)
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

