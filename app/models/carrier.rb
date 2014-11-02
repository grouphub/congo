class Carrier < ActiveRecord::Base
  before_save :add_slug

  has_many :products

  def add_slug
    self.slug = Sluggerizer.sluggerize(self.name) if self.name
  end
end

