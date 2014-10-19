class CreateAccountUsers < ActiveRecord::Migration
  def change
    create_table :account_users do |t|
      t.integer :account_id
      t.integer :user_id

      t.timestamps
    end
  end
end
