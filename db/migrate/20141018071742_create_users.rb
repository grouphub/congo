class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :encrypted_password
      t.text :properties_data

      # Invitation system
      t.integer :invitation_id

      t.timestamps
    end
  end
end

