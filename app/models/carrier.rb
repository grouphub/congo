class Carrier < ActiveRecord::Base
  include Sluggable
  include Propertied

  belongs_to :account

  has_many :benefit_plans
  has_many :carrier_accounts
end

