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

ActiveRecord::Schema.define(version: 20150306005856) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "message_logs", force: true do |t|
    t.string   "user_id"
    t.string   "channel"
    t.string   "msg_type"
    t.string   "msg_subtype"
    t.integer  "slack_room_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "timestamp"
    t.text     "msg_text"
  end

  add_index "message_logs", ["slack_room_id"], name: "index_message_logs_on_slack_room_id", using: :btree

  create_table "slack_rooms", force: true do |t|
    t.string   "handle"
    t.string   "token"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "general_channel"
  end

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "real_name"
    t.string   "slack_handle"
    t.string   "email"
    t.string   "image_url"
    t.string   "slack_user_id"
    t.integer  "slack_room_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
