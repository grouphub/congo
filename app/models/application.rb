class Application < ActiveRecord::Base
  include Proper

  belongs_to :account
  belongs_to :benefit_plan
  belongs_to :membership
end
