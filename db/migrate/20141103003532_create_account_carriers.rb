class CreateAccountCarriers < ActiveRecord::Migration
  def change
    create_table :account_carriers do |t|
      t.integer :account_id
      t.integer :carrier_id
      t.string :name
      t.text :properties_data

      t.timestamps
    end
  end
end
