class Payment < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :account
end

