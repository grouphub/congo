# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141119053011) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "tagline"
    t.string   "plan_name"
    t.text     "properties_data"
    t.string   "card_number"
    t.string   "month"
    t.string   "year"
    t.string   "cvc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "application_details", force: true do |t|
    t.integer  "application_id"
    t.integer  "carrier_id"
    t.string   "master_policy_number"
    t.integer  "group_id"
    t.string   "group_or_policy_number"
    t.string   "sponsor_tax_id"
    t.string   "payer_tax_id"
    t.string   "payer_responsibility"
    t.integer  "member_id"
    t.string   "enrollment_reference_number"
    t.string   "enrollment_action"
    t.string   "enrollment_event"
    t.date     "enrollment_date"
    t.string   "enrollment_maintenance_reason"
    t.string   "enrollment_maintenance_type"
    t.string   "subscriber_eligibility_begin_date"
    t.integer  "subscriber_number"
    t.string   "subscriber_first_name"
    t.string   "subscriber_middle_name"
    t.string   "subscriber_last_name"
    t.string   "subscriber_ssn"
    t.string   "subscriber_address_1"
    t.string   "subscriber_address_2"
    t.string   "subscriber_city"
    t.string   "subscriber_state"
    t.integer  "subscriber_zip"
    t.string   "subscriber_home_phone"
    t.string   "subscriber_date_of_birth"
    t.integer  "subscriber_gender"
    t.string   "subscriber_marital_status"
    t.string   "subscriber_employer"
    t.string   "subscriber_employment_status"
    t.date     "subscriber_hire_date"
    t.string   "subscriber_job_title"
    t.string   "subscriber_benefit_status"
    t.integer  "subscriber_benefit_plan_id"
    t.string   "subscriber_substance_abuse"
    t.string   "subscriber_tobacco_use"
    t.integer  "subscriber_dependents_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "applications", force: true do |t|
    t.integer  "account_id"
    t.integer  "benefit_plan_id"
    t.integer  "membership_id"
    t.text     "properties_data"
    t.integer  "selected_by_id"
    t.datetime "selected_on"
    t.integer  "applied_by_id"
    t.datetime "applied_on"
    t.integer  "declined_by_id"
    t.datetime "declined_on"
    t.integer  "approved_by_id"
    t.datetime "approved_on"
    t.integer  "submitted_by_id"
    t.datetime "submitted_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "benefit_plans", force: true do |t|
    t.integer  "account_id"
    t.integer  "carrier_account_id"
    t.string   "name"
    t.string   "slug"
    t.string   "type"
    t.boolean  "exchange_plan"
    t.boolean  "small_group"
    t.text     "properties_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "carrier_accounts", force: true do |t|
    t.integer  "account_id"
    t.integer  "carrier_id"
    t.string   "name"
    t.text     "properties_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "carriers", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.text     "properties_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "dependents", force: true do |t|
    t.integer  "application_id"
    t.integer  "carrier_id"
    t.string   "master_policy_number"
    t.integer  "group_id"
    t.integer  "member_id"
    t.string   "enrollment_reference_number"
    t.date     "enrollment_date"
    t.integer  "subscriber_number"
    t.string   "dependent_type"
    t.boolean  "dependent_coverage_refusal"
    t.integer  "dependent_coverage_refusal_id"
    t.string   "dependent_first_name"
    t.string   "dependent_middle_name"
    t.string   "dependent_last_name"
    t.string   "dependent_ssn"
    t.string   "dependent_address_1"
    t.string   "dependent_address_2"
    t.string   "dependent_city"
    t.string   "dependent_state"
    t.integer  "dependent_zip"
    t.string   "dependent_home_phone"
    t.string   "dependent_date_of_birth"
    t.integer  "dependent_gender"
    t.boolean  "dependent_disabled"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "group_benefit_plans", force: true do |t|
    t.integer  "group_id"
    t.integer  "benefit_plan_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", force: true do |t|
    t.integer  "account_id"
    t.string   "name"
    t.string   "slug"
    t.boolean  "is_enabled"
    t.text     "properties_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invitations", force: true do |t|
    t.string   "uuid"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memberships", force: true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.string   "email"
    t.string   "email_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", force: true do |t|
    t.integer  "account_id"
    t.integer  "cents"
    t.text     "properties"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: true do |t|
    t.integer  "account_id"
    t.integer  "user_id"
    t.string   "name"
    t.string   "english_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscriber_benefits", force: true do |t|
    t.integer  "carrier_id"
    t.string   "master_policy_number"
    t.integer  "group_id"
    t.string   "group_or_policy_number"
    t.integer  "member_id"
    t.string   "enrollment_reference_number"
    t.date     "enrollment_date"
    t.integer  "subscriber_number"
    t.integer  "benefit_plan_id"
    t.date     "benefit_begin_date"
    t.string   "benefit_type"
    t.boolean  "benefit_late_enrollment"
    t.string   "benefit_maintenance_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscriber_dependents", force: true do |t|
    t.integer  "application_id"
    t.integer  "carrier_id"
    t.string   "master_policy_number"
    t.integer  "group_id"
    t.integer  "member_id"
    t.string   "enrollment_reference_number"
    t.date     "enrollment_date"
    t.integer  "subscriber_number"
    t.string   "dependent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "encrypted_password"
    t.text     "properties_data"
    t.integer  "invitation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
