class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer :account_id
      t.integer :account_carrier_id
      t.string :name
      t.string :slug

      t.timestamps
    end
  end
end
