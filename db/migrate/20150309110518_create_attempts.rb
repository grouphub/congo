class CreateAttempts < ActiveRecord::Migration
  def change
    create_table :attempts do |t|
      t.integer :application_id
      t.string :error_type
      t.string :activity_id
      t.text :response_data

      # TODO: What fields do we need?
      t.text :properties_data

      t.timestamps
    end
  end
end

