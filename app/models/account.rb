require "#{Rails.root}/lib/sluggerizer"
#test
class Account < ActiveRecord::Base
  has_many :account_users

  before_save :add_slug

  def add_slug
    self.slug = Sluggerizer.sluggerize(self.name)
  end

  def simple_hash
    {
      name: self.name,
      slug: self.slug
    }
  end
end

