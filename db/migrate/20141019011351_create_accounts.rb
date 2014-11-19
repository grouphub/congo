class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :slug
      t.string :tagline
      t.string :plan_name

      # TODO: What fields do we need?
      t.text :properties_data

      # Payment info
      t.string :card_number
      t.string :month
      t.string :year
      t.string :cvc

      t.timestamps
    end
  end
end
