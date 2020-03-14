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

ActiveRecord::Schema.define(version: 2020_03_13_214100) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "absences", force: :cascade do |t|
    t.integer "employee_id"
    t.date "date"
    t.string "comment"
    t.boolean "is_paid"
    t.float "quantity"
  end

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "advances", force: :cascade do |t|
    t.integer "employee_id"
    t.float "amount"
    t.date "date"
    t.string "comments"
    t.boolean "is_paid_back"
    t.string "approval_status"
    t.string "approved_by"
  end

  create_table "bonuses", force: :cascade do |t|
    t.integer "employee_id"
    t.date "date"
    t.float "amount"
    t.string "bonus_type"
    t.string "comments"
    t.string "approval_status"
    t.string "approved_by"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.integer "employee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "employee_benefit_plans", force: :cascade do |t|
    t.float "annual_leaves"
    t.float "casual_leaves"
    t.float "compensation_leaves"
    t.float "sick_leaves"
    t.boolean "health_insurance"
    t.integer "employee_id"
  end

  create_table "employee_compensations", force: :cascade do |t|
    t.integer "employee_id"
    t.integer "salary"
    t.integer "EOBI_percentage"
  end

  create_table "employees", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "cnic", null: false
    t.boolean "can_login"
    t.date "joining_date", null: false
    t.string "office_location", null: false
    t.string "employee_type", null: false
    t.string "address"
    t.string "phone_number"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.integer "manager_id"
    t.string "status"
    t.string "reason_for_leaving"
    t.boolean "do_not_rehire", default: false, null: false
  end

  create_table "leaves", force: :cascade do |t|
    t.string "leave_type"
    t.float "quantity"
    t.integer "employee_id"
    t.date "date"
    t.string "comments"
    t.boolean "require_approval"
    t.string "approval_status"
    t.string "approved_by"
  end

  create_table "overtimes", force: :cascade do |t|
    t.integer "employee_id"
    t.integer "number_of_hours"
    t.date "date"
    t.string "reason"
    t.string "approved_by"
    t.string "approval_status"
  end

  create_table "payrolls", force: :cascade do |t|
    t.integer "employee_id"
    t.date "payroll_generated_date"
    t.date "payroll_month"
    t.integer "base_salary"
    t.integer "bonus"
    t.integer "overtime"
    t.integer "advances"
    t.integer "absence_deduction"
    t.integer "advance_return"
    t.integer "taxable_amount"
    t.integer "actual_amount"
    t.integer "eobi"
    t.integer "tax"
    t.integer "gross_pay"
    t.boolean "paid"
  end

  create_table "system_users", force: :cascade do |t|
    t.string "user_name", null: false
    t.string "encrypted_password", null: false
    t.string "system_role"
    t.string "employee_id"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_name"], name: "index_system_users_on_user_name", unique: true
  end

  create_table "tax_slabs", force: :cascade do |t|
    t.float "income_start"
    t.float "income_end"
    t.float "fixed_tax"
    t.float "percentage_tax"
    t.date "tax_slab_year_start"
    t.date "tax_slab_year_end"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
end
