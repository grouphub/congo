class Application < ActiveRecord::Base
  belongs_to :account
  belongs_to :product
  belongs_to :membership

  def simple_hash
    {
      id: self.id,
      product_id: self.product_id,
      membership_id: self.membership_id,
      created_at: self.created_at,
      updated_at: self.updated_at,
      product: self.product,
      membership: self.membership.simple_hash_with_group
    }
  end
end
