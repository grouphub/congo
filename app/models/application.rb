class Application < ActiveRecord::Base
  belongs_to :account
  belongs_to :benefit_plan
  belongs_to :membership
end
