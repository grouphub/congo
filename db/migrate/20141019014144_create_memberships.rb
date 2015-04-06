class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.integer :account_id
      t.integer :user_id
      t.integer :group_id
      t.string :role_name
      t.integer :role_id
      t.string :email
      t.string :email_token

      t.timestamps

      t.datetime :deleted_at
      t.index :deleted_at
    end
  end
end

