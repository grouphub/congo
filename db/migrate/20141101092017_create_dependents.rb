class CreateDependents < ActiveRecord::Migration
  def change
    create_table :dependents do |t|
      t.integer   :application_id
      t.integer   :carrier_id
      t.string    :master_policy_number 
      t.integer   :group_id
      t.integer   :member_id
      t.string 	:enrollment_reference_number
      t.date 	:enrollment_date
      t.integer   :subscriber_number
      t.string    :dependent_type
      t.boolean   :dependent_coverage_refusal
      t.integer   :dependent_coverage_refusal_id
      t.string 	:dependent_first_name
      t.string 	:dependent_middle_name
      t.string 	:dependent_last_name
      t.string 	:dependent_ssn
      t.string 	:dependent_address_1
      t.string 	:dependent_address_2
      t.string 	:dependent_city
      t.string 	:dependent_state
      t.integer   :dependent_zip
      t.string 	:dependent_home_phone
      t.string 	:dependent_date_of_birth
      t.integer	:dependent_gender
      t.timestamps
    end
  end
end

