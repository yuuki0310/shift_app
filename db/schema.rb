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

ActiveRecord::Schema[7.0].define(version: 2022_09_29_090706) do
  create_table "affiliation_applications", force: :cascade do |t|
    t.integer "user_id"
    t.integer "store_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["store_id"], name: "index_affiliation_applications_on_store_id"
    t.index ["user_id"], name: "index_affiliation_applications_on_user_id"
  end

  create_table "shift_sections", force: :cascade do |t|
    t.integer "store_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.date "beginning"
    t.date "ending"
    t.integer "status"
    t.index ["store_id"], name: "index_shift_sections_on_store_id"
  end

  create_table "shifts", force: :cascade do |t|
    t.integer "store_id"
    t.date "date"
    t.time "working_time_from"
    t.time "working_time_to"
    t.integer "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["store_id"], name: "index_shifts_on_store_id"
    t.index ["user_id"], name: "index_shifts_on_user_id"
  end

  create_table "store_month_schedules", force: :cascade do |t|
    t.integer "store_id"
    t.date "date"
    t.time "working_time_from"
    t.time "working_time_to"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "count"
    t.index ["store_id"], name: "index_store_month_schedules_on_store_id"
  end

  create_table "store_weekly_schedules", force: :cascade do |t|
    t.time "working_time_from"
    t.time "working_time_to"
    t.integer "count"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "store_id"
    t.integer "weeklyday_id"
    t.index ["store_id"], name: "index_store_weekly_schedules_on_store_id"
    t.index ["weeklyday_id"], name: "index_store_weekly_schedules_on_weeklyday_id"
  end

  create_table "stores", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "owner_id"
    t.string "public_uid"
    t.index ["owner_id"], name: "index_stores_on_owner_id"
  end

  create_table "user_submissions", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "shift_section_id"
    t.index ["shift_section_id"], name: "index_user_submissions_on_shift_section_id"
    t.index ["user_id"], name: "index_user_submissions_on_user_id"
  end

  create_table "user_unable_schedules", force: :cascade do |t|
    t.integer "user_id"
    t.date "date"
    t.time "working_time_from"
    t.time "working_time_to"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id"], name: "index_user_unable_schedules_on_user_id"
  end

  create_table "user_weekly_schedules", force: :cascade do |t|
    t.integer "user_id"
    t.integer "weeklyday_id"
    t.time "working_time_from"
    t.time "working_time_to"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id"], name: "index_user_weekly_schedules_on_user_id"
    t.index ["weeklyday_id"], name: "index_user_weekly_schedules_on_weeklyday_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "store_id"
    t.integer "working_desired_time"
    t.string "email"
    t.string "password_digest"
    t.string "public_uid"
    t.integer "Store_id_id"
    t.index ["public_uid"], name: "index_users_on_public_uid", unique: true
    t.index ["store_id"], name: "index_users_on_store_id"
  end

  create_table "weeklydays", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  add_foreign_key "affiliation_applications", "stores"
  add_foreign_key "affiliation_applications", "users"
  add_foreign_key "shift_sections", "stores"
  add_foreign_key "shifts", "stores"
  add_foreign_key "shifts", "users"
  add_foreign_key "store_month_schedules", "stores"
  add_foreign_key "store_weekly_schedules", "stores"
  add_foreign_key "store_weekly_schedules", "weeklydays"
  add_foreign_key "stores", "users", column: "owner_id"
  add_foreign_key "user_submissions", "shift_sections"
  add_foreign_key "user_submissions", "users"
  add_foreign_key "user_unable_schedules", "users"
  add_foreign_key "user_weekly_schedules", "users"
  add_foreign_key "user_weekly_schedules", "weeklydays"
  add_foreign_key "users", "stores"
end
