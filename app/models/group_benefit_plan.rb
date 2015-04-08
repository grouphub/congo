class GroupBenefitPlan < ActiveRecord::Base
  include Propertied

  acts_as_paranoid

  belongs_to :account
  belongs_to :group
  belongs_to :benefit_plan
end

