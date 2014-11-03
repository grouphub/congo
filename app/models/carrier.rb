class Carrier < ActiveRecord::Base
  include Sluggable
  include Proper

  has_many :benefit_plans
  has_many :account_carriers
end

