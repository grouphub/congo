class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.string :name
      t.string :unique_id
      t.integer :account_id

      t.timestamps
    end
  end
end
