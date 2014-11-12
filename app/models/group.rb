class Group < ActiveRecord::Base
  include Sluggable
  include Propertied

  has_many :memberships
  has_many :group_benefit_plans

  belongs_to :account
end

