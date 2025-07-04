# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_06_22_183154) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "audit_logs", force: :cascade do |t|
    t.string "action"
    t.string "performed_by_type", null: false
    t.bigint "performed_by_id", null: false
    t.jsonb "details"
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["performed_by_type", "performed_by_id"], name: "index_audit_logs_on_performed_by"
  end

  create_table "device_locks", force: :cascade do |t|
    t.string "reason"
    t.datetime "locked_at"
    t.datetime "unlocked_at"
    t.boolean "manually_locked"
    t.bigint "device_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["device_id"], name: "index_device_locks_on_device_id"
  end

  create_table "devices", force: :cascade do |t|
    t.string "name"
    t.string "imei"
    t.string "serial_number"
    t.string "model"
    t.integer "purchasing_price"
    t.string "status", default: "available", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_devices_on_user_id"
  end

  create_table "installment_plans", force: :cascade do |t|
    t.integer "total_amount"
    t.integer "amount_paid"
    t.integer "monthly_payment"
    t.integer "due_day"
    t.date "start_date"
    t.date "end_date"
    t.string "status", default: "active", null: false
    t.boolean "locked"
    t.bigint "user_id", null: false
    t.bigint "device_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["device_id"], name: "index_installment_plans_on_device_id"
    t.index ["user_id"], name: "index_installment_plans_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.integer "amount"
    t.date "payment_date"
    t.string "status"
    t.string "method"
    t.string "currency"
    t.string "trans_reference"
    t.string "external_ref"
    t.bigint "installment_plan_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["installment_plan_id"], name: "index_payments_on_installment_plan_id"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "token"
    t.string "expired_at"
    t.string "ip_address"
    t.string "user_agent"
    t.string "last_active_at"
    t.string "owner_type", null: false
    t.bigint "owner_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_type", "owner_id"], name: "index_sessions_on_owner"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "password_digest"
    t.string "phone_number"
    t.string "national_id"
    t.string "home_address"
    t.string "status", default: "active", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "devices", "users"
  add_foreign_key "installment_plans", "devices"
  add_foreign_key "installment_plans", "users"
  add_foreign_key "payments", "installment_plans"
  add_foreign_key "payments", "users"
end
