class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.integer :account_id
      t.string :name
      t.string :slug
      t.boolean :is_enabled
      t.text :description_markdown
      t.text :description_html

      # TODO: What fields do we need?
      t.text :properties_data

      t.timestamps
    end
  end
end
