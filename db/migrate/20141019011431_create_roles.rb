class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.integer :account_id
      t.integer :user_id
      t.string :name
      t.string :english_name

      t.timestamps
    end
  end
end
