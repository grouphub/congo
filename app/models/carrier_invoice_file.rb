class CarrierInvoiceFile < ActiveRecord::Base
  belongs_to :group
  belongs_to :carrier
end
