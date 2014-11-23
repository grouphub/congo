class Carrier < ActiveRecord::Base
  include Sluggable
  include Propertied

  has_many :benefit_plans
  has_many :carrier_accounts
end

