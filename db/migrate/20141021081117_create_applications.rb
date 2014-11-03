class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.integer :account_id
      t.integer :benefit_plan_id
      t.integer :membership_id

      t.timestamps
    end
  end
end
