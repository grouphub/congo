class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :slug
      t.string :email
      t.string :encrypted_password
      t.text :roles_data

      t.timestamps
    end
  end
end

