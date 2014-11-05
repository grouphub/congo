class Group < ActiveRecord::Base
  include Sluggable

  has_many :memberships
  has_many :group_benefit_plans

  belongs_to :account
end

