class ApplicationStatus < ActiveRecord::Base
  belongs_to :application

  acts_as_paranoid
end

