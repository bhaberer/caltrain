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

ActiveRecord::Schema.define(version: 20150916000737) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "stations", force: :cascade do |t|
    t.string   "name"
    t.integer  "sequence"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "zone"
    t.string   "uid"
  end

  create_table "stops", force: :cascade do |t|
    t.datetime "time"
    t.integer  "train_id"
    t.integer  "station_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "direction"
  end

  add_index "stops", ["station_id"], name: "index_stops_on_station_id", using: :btree
  add_index "stops", ["train_id"], name: "index_stops_on_train_id", using: :btree

  create_table "trains", force: :cascade do |t|
    t.integer  "number"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "schedule"
    t.string   "direction"
    t.datetime "origin_time"
  end

  add_foreign_key "stops", "stations"
  add_foreign_key "stops", "trains"
end
