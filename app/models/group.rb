class Group < ActiveRecord::Base
  has_many :memberships
  has_many :group_products

  before_save :add_slug

  def add_slug
    self.slug = Sluggerizer.sluggerize(self.name)
  end

  def simple_hash
    {
      id: self.id,
      name: self.name,
      slug: self.slug,
      memberships: self.memberships.map { |membership| membership.simple_hash },
      products: self
        .group_products
        .includes(:product)
        .map { |group_product| group_product.product }
    }
  end
end

