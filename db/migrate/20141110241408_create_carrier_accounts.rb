class CreateCarrierAccounts < ActiveRecord::Migration
  def change
    create_table :carrier_accounts do |t|
     t.integer 	:carrier_id
      t.integer :broker_id
      t.string 	:broker_number
      t.string 	:brokerage_name
      t.string 	:tax_id

      t.timestamps
    end
  end
end
