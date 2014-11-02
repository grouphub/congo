class CreateCarriers < ActiveRecord::Migration
  def change
    create_table :carriers do |t|
      t.string :name
      t.string :slug
      t.integer :carrier_number
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
