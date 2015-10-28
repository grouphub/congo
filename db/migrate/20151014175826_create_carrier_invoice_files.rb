class CreateCarrierInvoiceFiles < ActiveRecord::Migration
  def change
    create_table :carrier_invoice_files do |t|
      t.integer :carrier_id
      t.integer :group_id
      t.string :location
    end
  end
end
