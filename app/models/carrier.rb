class Carrier < ActiveRecord::Base
  include Sluggable
  include Propertied

  has_many :benefit_plans
  has_many :account_carriers
end

