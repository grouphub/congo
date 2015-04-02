class CreateAccountBenefitPlans < ActiveRecord::Migration
  def change
    create_table :account_benefit_plans do |t|
      t.integer :account_id
      t.integer :carrier_id
      t.integer :carrier_account_id
      t.integer :benefit_plan_id
      t.text :properties_data

      t.timestamps null: false
    end
  end
end
