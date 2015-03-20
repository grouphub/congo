class CreateBenefitPlans < ActiveRecord::Migration
  def change
    create_table :benefit_plans do |t|
      t.integer :account_id
      t.integer :carrier_account_id
      t.string :name
      t.string :slug
      t.boolean :is_enabled
      t.text :description_markdown
      t.text :description_html

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
