class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.integer :account_id
      t.integer :benefit_plan_id
      t.integer :membership_id

      # Customer applies
      t.integer :applied_by_id

      # Group admin approves
      t.integer :approved_by_id

      # Broker submits
      t.integer :submitted_by_id

      t.timestamps
    end
  end
end
