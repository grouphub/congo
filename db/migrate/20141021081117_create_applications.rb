class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.integer :account_id
      t.integer :benefit_plan_id
      t.integer :membership_id

      # This gets sent to PokitDok
      t.string :reference_number

      # TODO: What fields do we need?
      t.text :properties_data

      # Customer selects
      t.integer :selected_by_id
      t.datetime :selected_on

      # Customer applies
      t.integer :applied_by_id
      t.datetime :applied_on

      # Customer declines
      t.integer :declined_by_id
      t.datetime :declined_on

      # Group admin approves
      t.integer :approved_by_id
      t.datetime :approved_on

      # Broker submits
      t.integer :submitted_by_id
      t.datetime :submitted_on

      # System completes
      t.integer :completed_by_id
      t.datetime :completed_on

      # Error state
      t.boolean :errored_by_id
      t.datetime :errored_on

      # The activity_id we get from PokitDok
      t.string :activity_id

      t.timestamps
    end
  end
end
