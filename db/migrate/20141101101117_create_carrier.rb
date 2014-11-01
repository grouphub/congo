class CreateCarrier < ActiveRecord::Migration
  def change
    create_table :carrier do |t|
      t.integer   :carrier_number
      t.string 	:carrier_name
      t.string 	:carrier_address_1
      t.string 	:carrier_address_2
      t.string 	:carrier_city
      t.string 	:carrier_state
      t.integer   :carrier_zip
      t.string 	:carrier_phone
      
      t.timestamps
    end
  end
end

