class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :account_id
      t.integer :role_id
      t.string :subject_kind
      t.integer :subject_id
      t.string :title
      t.text :description

      t.timestamps

      t.datetime :deleted_at
      t.index :deleted_at

      t.datetime :read_at
      t.index :read_at
    end
  end
end
