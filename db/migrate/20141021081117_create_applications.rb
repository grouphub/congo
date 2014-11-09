class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.integer :account_id
      t.integer :benefit_plan_id
      t.integer :membership_id

      # Group admin approves
      t.integer :approved_by

      # Broker submits
      t.integer :submitted_by

      t.timestamps
    end
  end
end
