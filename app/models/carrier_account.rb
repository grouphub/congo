class CarrierAccount < ActiveRecord::Base
  include Propertied

  acts_as_paranoid

  belongs_to :account
  belongs_to :carrier

  has_many :benefit_plans
end

