class Group < ActiveRecord::Base
  has_many :memberships
  has_many :group_benefit_plans

  belongs_to :account

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
      benefit_plans: self
        .group_benefit_plans
        .includes(:benefit_plan)
        .map { |group_benefit_plan| group_benefit_plan.benefit_plan }
    }
  end
end

