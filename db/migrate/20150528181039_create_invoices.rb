class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer :account_id
      t.integer :membership_id
      t.integer :cents
      t.string :plan_name
      t.text :properties_data

      t.timestamps

      t.datetime :deleted_at
      t.index :deleted_at
    end
  end
end
