class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :account_id
      t.string :uuid
      t.text :description

      t.timestamps

      t.datetime :deleted_at
      t.index :deleted_at
    end
  end
end

