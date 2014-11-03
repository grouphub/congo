class GroupBenefitPlan < ActiveRecord::Base
  belongs_to :group
  belongs_to :benefit_plan
end

