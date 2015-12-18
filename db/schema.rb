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

ActiveRecord::Schema.define(version: 20151217100659) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "courses", force: :cascade do |t|
    t.string   "name"
    t.integer  "race_id"
    t.string   "description"
    t.date     "active_date"
    t.date     "close_date"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "courses", ["race_id"], name: "index_courses_on_race_id", using: :btree

  create_table "cyclists", force: :cascade do |t|
    t.string   "name"
    t.integer  "strava_id"
    t.string   "description"
    t.string   "gender"
    t.string   "age_range"
    t.date     "join_date"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "races", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "hashtag"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "results", force: :cascade do |t|
    t.time     "time"
    t.integer  "race_id"
    t.integer  "course_id"
    t.integer  "segment_id"
    t.integer  "cyclist_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "results", ["course_id"], name: "index_results_on_course_id", using: :btree
  add_index "results", ["cyclist_id"], name: "index_results_on_cyclist_id", using: :btree
  add_index "results", ["race_id"], name: "index_results_on_race_id", using: :btree
  add_index "results", ["segment_id"], name: "index_results_on_segment_id", using: :btree

  create_table "rosters", force: :cascade do |t|
    t.date     "join_date"
    t.integer  "race_id"
    t.integer  "cyclist_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "rosters", ["cyclist_id"], name: "index_rosters_on_cyclist_id", using: :btree
  add_index "rosters", ["race_id"], name: "index_rosters_on_race_id", using: :btree

  create_table "segments", force: :cascade do |t|
    t.string   "strava_url"
    t.integer  "strava_id"
    t.string   "description"
    t.float    "length"
    t.integer  "course_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "segments", ["course_id"], name: "index_segments_on_course_id", using: :btree

  add_foreign_key "courses", "races"
  add_foreign_key "results", "courses"
  add_foreign_key "results", "cyclists"
  add_foreign_key "results", "races"
  add_foreign_key "results", "segments"
  add_foreign_key "rosters", "cyclists"
  add_foreign_key "rosters", "races"
  add_foreign_key "segments", "courses"
end
