class CreateGroupBenefitPlans < ActiveRecord::Migration
  def change
    create_table :group_benefit_plans do |t|
      t.integer :account_id
      t.integer :group_id
      t.integer :benefit_plan_id

      t.timestamps
    end
  end
end
