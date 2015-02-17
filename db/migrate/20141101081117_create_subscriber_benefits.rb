class CreateSubscriberBenefits < ActiveRecord::Migration
  def change
    create_table :subscriber_benefits do |t|
      t.integer :carrier_id
      t.string :master_policy_number
      t.integer :group_id
      t.string :group_or_policy_number
      t.integer :member_id
      t.string :enrollment_reference_number
      t.date :enrollment_date
      t.integer :subscriber_number
      t.integer :benefit_plan_id
      t.date :benefit_begin_date
      t.string :benefit_type
      t.boolean :benefit_late_enrollment
      t.string :benefit_maintenance_type

      t.timestamps
    end
  end
end

