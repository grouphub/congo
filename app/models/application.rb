class Application < ActiveRecord::Base
  include Propertied

  belongs_to :account
  belongs_to :benefit_plan
  belongs_to :membership
end
