class Product < ActiveRecord::Base
  has_many :group_products
  has_many :applications

  belongs_to :account

  before_save :add_slug

  def add_slug
    self.slug = Sluggerizer.sluggerize(self.name)
  end
end

