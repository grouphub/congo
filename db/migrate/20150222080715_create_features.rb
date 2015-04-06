class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.string :name
      t.text :description
      t.boolean :enabled_for_all
      t.text :account_slug_data

      t.timestamps

      t.datetime :deleted_at
      t.index :deleted_at
    end
  end
end

