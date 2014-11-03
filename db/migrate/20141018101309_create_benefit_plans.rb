class CreateBenefitPlans < ActiveRecord::Migration
  def change
    create_table :benefit_plans do |t|
      t.integer :account_id
      t.integer :account_carrier_id
      t.string :name
      t.string :slug

      t.string :type
      t.boolean :exchange_plan
      t.boolean :small_group

      # Fields:
      #
      # * plan_type
      # * exchange_plan
      # * small_group
      t.text :properties_data

      t.timestamps
    end
  end
end
