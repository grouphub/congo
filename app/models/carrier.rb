class Carrier < ActiveRecord::Base
  before_save :add_slug

  def add_slug
    self.slug = Sluggerizer.sluggerize(self.name) if self.name
  end
end

