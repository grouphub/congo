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

<<<<<<< HEAD
ActiveRecord::Schema.define(version: 20151014175826) do
=======
ActiveRecord::Schema.define(version: 20150907170842) do
>>>>>>> 43b8c25ebc78f40533620f7803972260d964f35c

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_benefit_plans", force: :cascade do |t|
    t.integer  "account_id"
    t.integer  "carrier_id"
    t.integer  "carrier_account_id"
    t.integer  "benefit_plan_id"
    t.text     "properties_data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "account_benefit_plans", ["deleted_at"], name: "index_account_benefit_plans_on_deleted_at", using: :btree

  create_table "accounts", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "tagline"
    t.string   "plan_name"
    t.text     "properties_data"
    t.string   "card_number"
    t.string   "month"
    t.string   "year"
    t.string   "cvc"
    t.datetime "billing_start"
    t.integer  "billing_day"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "accounts", ["deleted_at"], name: "index_accounts_on_deleted_at", using: :btree

  create_table "application_statuses", force: :cascade do |t|
    t.integer  "account_id"
    t.integer  "application_id"
    t.text     "payload"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "application_statuses", ["deleted_at"], name: "index_application_statuses_on_deleted_at", using: :btree

  create_table "applications", force: :cascade do |t|
    t.integer  "account_id"
    t.integer  "benefit_plan_id"
    t.integer  "membership_id"
    t.string   "reference_number"
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
    t.integer  "completed_by_id"
    t.datetime "completed_on"
    t.boolean  "errored_by_id"
    t.datetime "errored_on"
    t.string   "activity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string   "pdf_attachment_url"
  end

  add_index "applications", ["deleted_at"], name: "index_applications_on_deleted_at", using: :btree

  create_table "attachments", force: :cascade do |t|
    t.integer  "account_id"
    t.integer  "benefit_plan_id"
    t.integer  "group_id"
    t.string   "filename"
    t.string   "content_type"
    t.string   "title"
    t.string   "url"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "attachments", ["deleted_at"], name: "index_attachments_on_deleted_at", using: :btree

  create_table "benefit_plans", force: :cascade do |t|
    t.integer  "account_id"
    t.integer  "carrier_account_id"
    t.integer  "carrier_id"
    t.string   "name"
    t.string   "slug"
    t.boolean  "is_enabled"
    t.text     "description_markdown"
    t.text     "description_html"
    t.text     "properties_data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "benefit_plans", ["deleted_at"], name: "index_benefit_plans_on_deleted_at", using: :btree

  create_table "carrier_accounts", force: :cascade do |t|
    t.integer  "account_id"
    t.integer  "carrier_id"
    t.string   "name"
    t.text     "properties_data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "carrier_accounts", ["deleted_at"], name: "index_carrier_accounts_on_deleted_at", using: :btree

  create_table "carrier_invoice_files", force: :cascade do |t|
    t.integer "carrier_id"
    t.integer "group_id"
    t.string  "location"
  end

  create_table "carriers", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.integer  "account_id"
    t.text     "properties_data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "carriers", ["deleted_at"], name: "index_carriers_on_deleted_at", using: :btree

  create_table "features", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "enabled_for_all"
    t.text     "account_slug_data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "features", ["deleted_at"], name: "index_features_on_deleted_at", using: :btree

  create_table "group_benefit_plans", force: :cascade do |t|
    t.integer  "account_id"
    t.integer  "group_id"
    t.integer  "benefit_plan_id"
    t.text     "properties_data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "group_benefit_plans", ["deleted_at"], name: "index_group_benefit_plans_on_deleted_at", using: :btree

  create_table "groups", force: :cascade do |t|
    t.integer  "account_id"
    t.string   "name"
    t.string   "slug"
    t.boolean  "is_enabled"
    t.text     "description_markdown"
    t.text     "description_html"
    t.text     "properties_data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.integer  "number_of_members"
    t.string   "industry"
    t.string   "website"
    t.string   "phone_number"
    t.integer  "zip_code"
    t.integer  "tax_id"
  end

  add_index "groups", ["deleted_at"], name: "index_groups_on_deleted_at", using: :btree

  create_table "invitations", force: :cascade do |t|
    t.integer  "account_id"
    t.string   "uuid"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "invitations", ["deleted_at"], name: "index_invitations_on_deleted_at", using: :btree

  create_table "invoices", force: :cascade do |t|
    t.integer  "account_id"
    t.integer  "membership_id"
    t.integer  "cents"
    t.string   "plan_name"
    t.integer  "payment_id"
    t.boolean  "paid"
    t.text     "properties_data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "invoices", ["deleted_at"], name: "index_invoices_on_deleted_at", using: :btree

  create_table "memberships", force: :cascade do |t|
    t.integer  "account_id"
    t.integer  "user_id"
    t.integer  "group_id"
    t.string   "role_name"
    t.integer  "role_id"
    t.string   "email"
    t.string   "email_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "memberships", ["deleted_at"], name: "index_memberships_on_deleted_at", using: :btree

  create_table "notifications", force: :cascade do |t|
    t.integer  "account_id"
    t.integer  "role_id"
    t.string   "subject_kind"
    t.integer  "subject_id"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.datetime "read_at"
  end

  add_index "notifications", ["deleted_at"], name: "index_notifications_on_deleted_at", using: :btree
  add_index "notifications", ["read_at"], name: "index_notifications_on_read_at", using: :btree

  create_table "payments", force: :cascade do |t|
    t.integer  "account_id"
    t.integer  "cents"
    t.text     "properties"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "payments", ["deleted_at"], name: "index_payments_on_deleted_at", using: :btree

  create_table "roles", force: :cascade do |t|
    t.integer  "account_id"
    t.integer  "user_id"
    t.string   "name"
    t.string   "english_name"
    t.integer  "invitation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "roles", ["deleted_at"], name: "index_roles_on_deleted_at", using: :btree

  create_table "tokens", force: :cascade do |t|
    t.string   "name"
    t.string   "unique_id"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "tokens", ["deleted_at"], name: "index_tokens_on_deleted_at", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "encrypted_password"
    t.string   "password_token"
    t.text     "properties_data"
    t.integer  "invitation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string   "phone"
  end

  add_index "users", ["deleted_at"], name: "index_users_on_deleted_at", using: :btree

end
