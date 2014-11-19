module Sluggable
  extend ActiveSupport::Concern

  included do
    before_save :add_slug
  end

  def add_slug
    self.slug = Sluggerizer.sluggerize(self.name) if self.name
  end
end

