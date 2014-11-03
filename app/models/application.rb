class Application < ActiveRecord::Base
  belongs_to :account
  belongs_to :benefit_plan
  belongs_to :membership

  def simple_hash
    {
      id: self.id,
      benefit_plan_id: self.benefit_plan_id,
      membership_id: self.membership_id,
      created_at: self.created_at,
      updated_at: self.updated_at,
      benefit_plan: self.benefit_plan,
      membership: self.membership.simple_hash_with_group
    }
  end
end
