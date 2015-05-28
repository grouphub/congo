class Invoice < ActiveRecord::Base
  include Propertied

  acts_as_paranoid

  belongs_to :account
  belongs_to :membership
  belongs_to :payment

  PLAN_COSTS = {
    basic: 100,
    standard: 100,
    premier: 100,
    admin: 0
  }
end
