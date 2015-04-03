module Sluggable
  extend ActiveSupport::Concern

  def name=(n)
    write_attribute(:name, n)
    write_attribute(:slug, Sluggerizer.sluggerize(n)) if n
  end
end

