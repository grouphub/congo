class Attachment < ActiveRecord::Base
  belongs_to :account
  belongs_to :benefit_plan
end

