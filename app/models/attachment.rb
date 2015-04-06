class Attachment < ActiveRecord::Base
  belongs_to :account
  belongs_to :benefit_plan

  acts_as_paranoid
end

