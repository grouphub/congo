class AccountCarrier < ActiveRecord::Base
  include Proper

  belongs_to :account
  belongs_to :carrier

  has_many :benefit_plans
end

