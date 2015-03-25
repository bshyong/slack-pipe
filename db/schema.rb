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

ActiveRecord::Schema.define(version: 20150312200735) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "chat_rooms", force: true do |t|
    t.integer  "slack_room_id"
    t.string   "channel"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "message_logs", force: true do |t|
    t.string   "user_id"
    t.string   "channel"
    t.string   "msg_type"
    t.string   "msg_subtype"
    t.integer  "slack_room_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "timestamp",     limit: 8
    t.text     "msg_text"
    t.datetime "published_at"
    t.integer  "chat_room_id"
  end

  add_index "message_logs", ["chat_room_id"], name: "index_message_logs_on_chat_room_id", using: :btree
  add_index "message_logs", ["slack_room_id"], name: "index_message_logs_on_slack_room_id", using: :btree
  add_index "message_logs", ["timestamp", "channel"], name: "index_message_logs_on_timestamp_and_channel", unique: true, using: :btree

  create_table "slack_channels", force: true do |t|
    t.string   "slack_channel_id"
    t.string   "channel_name"
    t.integer  "slack_room_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "slack_channels", ["slack_room_id"], name: "index_slack_channels_on_slack_room_id", using: :btree

  create_table "slack_rooms", force: true do |t|
    t.string   "handle"
    t.string   "token"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "general_channel"
    t.boolean  "active",           default: false
    t.boolean  "publish_to_asm",   default: true
    t.boolean  "publish_to_slack", default: true
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
