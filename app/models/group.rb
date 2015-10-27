class Group < ActiveRecord::Base
  include Sluggable
  include Propertied

  acts_as_paranoid

  has_many :memberships
  has_many :group_benefit_plans
  has_many :attachments
  has_many :carrier_invoice_files

  belongs_to :account

  validates :name, uniqueness: true
end

