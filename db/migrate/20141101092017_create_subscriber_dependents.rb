class CreateSubscriberDependents < ActiveRecord::Migration
  def change
    create_table :subscriber_dependents do |t|
      t.integer   :application_id
      t.integer   :carrier_id
      t.string    :master_policy_number 
      t.integer   :group_id
      t.integer   :member_id
      t.string 	  :enrollment_reference_number
      t.date 	    :enrollment_date
      t.integer   :subscriber_number
      t.string    :dependent_id
      t.timestamps
    end
  end
end

