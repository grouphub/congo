class Application < ActiveRecord::Base
  belongs_to :account
  belongs_to :product
  belongs_to :membership
end
