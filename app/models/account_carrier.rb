class AccountCarrier < ActiveRecord::Base
  include Propertied

  belongs_to :account
  belongs_to :carrier

  has_many :benefit_plans
end

