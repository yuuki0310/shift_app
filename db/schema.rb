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

ActiveRecord::Schema.define(version: 2022_09_18_105754) do

  create_table "shifts", force: :cascade do |t|
    t.integer "store_id"
    t.date "date"
    t.time "working_time_from"
    t.time "working_time_to"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_shifts_on_store_id"
    t.index ["user_id"], name: "index_shifts_on_user_id"
  end

  create_table "store_month_schedules", force: :cascade do |t|
    t.integer "store_id"
    t.date "date"
    t.time "working_time_from"
    t.time "working_time_to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "count"
    t.index ["store_id"], name: "index_store_month_schedules_on_store_id"
  end

  create_table "store_schedules", force: :cascade do |t|
    t.time "working_time_from"
    t.time "working_time_to"
    t.integer "count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "store_id"
    t.integer "weeklyday_id"
    t.index ["store_id"], name: "index_store_schedules_on_store_id"
    t.index ["weeklyday_id"], name: "index_store_schedules_on_weeklyday_id"
  end

  create_table "store_shift_submissions", force: :cascade do |t|
    t.integer "store_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "beginning"
    t.date "ending"
    t.integer "status"
    t.index ["store_id"], name: "index_store_shift_submissions_on_store_id"
  end

  create_table "stores", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "owner_id"
    t.index ["owner_id"], name: "index_stores_on_owner_id"
  end

  create_table "submissions", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "store_shift_submission_id"
    t.index ["store_shift_submission_id"], name: "index_submissions_on_store_shift_submission_id"
    t.index ["user_id"], name: "index_submissions_on_user_id"
  end

  create_table "user_schedules", force: :cascade do |t|
    t.integer "user_id"
    t.integer "weeklyday_id"
    t.time "working_time_from"
    t.time "working_time_to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_schedules_on_user_id"
    t.index ["weeklyday_id"], name: "index_user_schedules_on_weeklyday_id"
  end

  create_table "user_unable_schedules", force: :cascade do |t|
    t.integer "user_id"
    t.date "date"
    t.time "working_time_from"
    t.time "working_time_to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_unable_schedules_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "store_id"
    t.integer "working_desired_time"
    t.string "email"
    t.string "password_digest"
    t.string "public_uid"
    t.index ["public_uid"], name: "index_users_on_public_uid", unique: true
    t.index ["store_id"], name: "index_users_on_store_id"
  end

  create_table "weeklydays", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
