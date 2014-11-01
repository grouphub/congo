class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.integer   :carrier_id
      t.string 	:plan_name
      t.string 	:plan_type
      t.boolean 	:exchange_plan
      t.boolean   :small_group
      t.timestamps
    end
  end
end

