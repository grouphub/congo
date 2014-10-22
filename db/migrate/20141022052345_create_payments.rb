class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :account_id
      t.integer :cents
      t.text :properties

      t.timestamps
    end
  end
end
