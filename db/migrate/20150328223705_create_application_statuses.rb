class CreateApplicationStatuses < ActiveRecord::Migration
  def change
    create_table :application_statuses do |t|
      t.integer :account_id
      t.integer :application_id
      t.text :payload

      t.timestamps

      t.datetime :deleted_at
      t.index :deleted_at
    end
  end
end

