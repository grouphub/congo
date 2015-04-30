class CreateSpreadsheetImports < ActiveRecord::Migration
  def change
    create_table :spreadsheet_imports do |t|
      t.integer :account_id
      t.integer :role_id # Who loaded it
      t.string :title
      t.text :description
      t.string :url
      t.string :filename

      t.datetime :completed_on
      t.datetime :errored_on
      t.text :error_message

      t.timestamps null: false

      t.datetime :deleted_at
      t.index :deleted_at
    end
  end
end
