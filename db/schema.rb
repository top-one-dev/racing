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

ActiveRecord::Schema.define(version: 20160111145126) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cyclists", force: :cascade do |t|
    t.string   "name"
    t.integer  "strava_id"
    t.string   "gender"
    t.string   "age_range"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "strava_athlete_url"
    t.string   "access_token"
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

  create_table "rosters", force: :cascade do |t|
    t.integer  "race_id"
    t.integer  "cyclist_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "rosters", ["cyclist_id"], name: "index_rosters_on_cyclist_id", using: :btree
  add_index "rosters", ["race_id"], name: "index_rosters_on_race_id", using: :btree

  create_table "segment_efforts", force: :cascade do |t|
    t.integer  "segment_id"
    t.integer  "stage_effort_id"
    t.integer  "segment_effort_id"
    t.integer  "elapsed_time"
    t.string   "strava_segment_url"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "segment_efforts", ["segment_id"], name: "index_segment_efforts_on_segment_id", using: :btree
  add_index "segment_efforts", ["stage_effort_id"], name: "index_segment_efforts_on_stage_effort_id", using: :btree

  create_table "segments", force: :cascade do |t|
    t.string   "strava_segment_url"
    t.integer  "strava_segment_id"
    t.string   "description"
    t.float    "length"
    t.integer  "stage_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "segments", ["stage_id"], name: "index_segments_on_stage_id", using: :btree

  create_table "stage_efforts", force: :cascade do |t|
    t.integer  "stage_id"
    t.integer  "cyclist_id"
    t.string   "strava_activity_url"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "elapsed_time"
  end

  add_index "stage_efforts", ["cyclist_id"], name: "index_stage_efforts_on_cyclist_id", using: :btree
  add_index "stage_efforts", ["stage_id"], name: "index_stage_efforts_on_stage_id", using: :btree

  create_table "stages", force: :cascade do |t|
    t.integer  "race_id"
    t.string   "name"
    t.string   "description"
    t.date     "active_date"
    t.date     "close_date"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "stage_no"
  end

  add_index "stages", ["race_id"], name: "index_stages_on_race_id", using: :btree

  add_foreign_key "rosters", "cyclists"
  add_foreign_key "rosters", "races"
  add_foreign_key "segment_efforts", "segments"
  add_foreign_key "segment_efforts", "stage_efforts"
  add_foreign_key "segments", "stages"
  add_foreign_key "stage_efforts", "cyclists"
  add_foreign_key "stage_efforts", "stages"
  add_foreign_key "stages", "races"
end
