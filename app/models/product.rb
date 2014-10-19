class Product < ActiveRecord::Base
  has_many :group_products
end

