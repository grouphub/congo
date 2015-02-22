class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.string :name
      t.text :description
      t.boolean :enabled_for_all
      t.text :account_slug_data

      t.timestamps
    end
  end
end

