class Group < ActiveRecord::Base
  include Sluggable
  include Propertied

  acts_as_paranoid

  has_many :memberships
  has_many :group_benefit_plans
  has_many :attachments

  belongs_to :account
end

