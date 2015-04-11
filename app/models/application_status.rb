class ApplicationStatus < ActiveRecord::Base
  belongs_to :application
  belongs_to :account_id

  acts_as_paranoid
end

