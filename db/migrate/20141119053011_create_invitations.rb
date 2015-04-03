class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :account_id
      t.string :uuid
      t.text :description

      t.timestamps
    end
  end
end
