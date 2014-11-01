class CreateApplicationDetails < ActiveRecord::Migration
  def change
    create_table :application_details do |t|
      t.integer :application_id
      t.integer :carrier_id
      t.string  :master_policy_number 
      t.integer :group_id
      t.string 	:group_or_policy_number
      t.string	:sponsor_tax_id
      t.string	:payer_tax_id
      t.string	:payer_responsibility
      t.integer :member_id
      t.string 	:enrollment_reference_number
      t.string 	:enrollment_action
      t.string 	:enrollment_event
      t.date 	:enrollment_date
      t.string	:enrollment_maintenance_reason
      t.string	:enrollment_maintenance_type
      t.string	:subscriber_eligibility_begin_date
      t.integer :subscriber_number
      t.string 	:subscriber_first_name
      t.string 	:subscriber_middle_name
      t.string 	:subscriber_last_name
      t.string 	:subscriber_ssn
      t.string 	:subscriber_address_1
      t.string 	:subscriber_address_2
      t.string 	:subscriber_city
      t.string 	:subscriber_state
      t.integer :subscriber_zip
      t.string 	:subscriber_home_phone
      t.string 	:subscriber_date_of_birth
      t.integer	:subscriber_gender
      t.string	:subscriber_marital_status
      t.string 	:subscriber_employer
      t.string 	:subscriber_employment_status
      t.date 	:subscriber_hire_date
      t.string 	:subscriber_job_title
      t.string	:subscriber_benefit_status
      t.integer	:subscriber_benefits_id
      t.string  :subscriber_substance_abuse
      t.string  :subscriber_tobacco_use

      t.timestamps
    end
  end
end

