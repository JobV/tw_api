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

ActiveRecord::Schema.define(version: 20150211221752) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "devices", force: true do |t|
    t.string  "token"
    t.string  "name"
    t.string  "os"
    t.integer "user_id"
  end

  add_index "devices", ["token"], :name => "index_devices_on_token"
  add_index "devices", ["user_id"], :name => "index_devices_on_user_id"

  create_table "friendships", force: true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "interaction_counter", default: 0
  end

  add_index "friendships", ["user_id", "friend_id"], :name => "index_friendships_on_user_id_and_friend_id", :unique => true

  create_table "locations", force: true do |t|
    t.spatial  "longlat",    limit: {:srid=>4326, :type=>"point", :has_z=>true, :has_m=>true, :geographic=>true}
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "locations", ["longlat"], :name => "index_locations_on_longlat", :spatial => true
  add_index "locations", ["user_id"], :name => "index_locations_on_user_id"

  create_table "meetup_requests", force: true do |t|
    t.integer  "friendship_id"
    t.integer  "status",        default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "friend_id"
  end

  add_index "meetup_requests", ["friendship_id"], :name => "index_meetup_requests_on_friendship_id"

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone_nr"
  end

end
