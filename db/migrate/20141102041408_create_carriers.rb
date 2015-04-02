class CreateCarriers < ActiveRecord::Migration
  def change
    create_table :carriers do |t|
      t.string :name
      t.string :slug
      t.integer :account_id

      # Fields:
      #
      # * npi
      # * first_name
      # * last_name
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
