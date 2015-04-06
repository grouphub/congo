class CreateCarrierAccounts < ActiveRecord::Migration
  def change
    create_table :carrier_accounts do |t|
      t.integer :account_id
      t.integer :carrier_id
      t.string :name
      t.text :properties_data

      t.timestamps

      t.datetime :deleted_at
      t.index :deleted_at
    end
  end
end

