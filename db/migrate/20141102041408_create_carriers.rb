class CreateCarriers < ActiveRecord::Migration
  def change
    create_table :carriers do |t|
      t.string :name
      t.string :slug

      # Fields:
      #
      # * carrier_number
      # * carrier_name
      # * address_1
      # * address_2
      # * city
      # * state
      # * zip
      # * phone
      t.text :properties_data

      t.timestamps
    end
  end
end
