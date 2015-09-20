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

ActiveRecord::Schema.define(version: 20150920041127) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cards", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.integer  "user_id"
    t.integer  "cards",       default: [],              array: true
    t.integer  "file_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "comments", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "submission_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "messages", force: :cascade do |t|
    t.string   "subject"
    t.text     "content"
    t.integer  "user_id"
    t.integer  "recipient_id"
    t.integer  "message_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "submission_id"
  end

  create_table "orders", force: :cascade do |t|
    t.json     "content",    null: false
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pools", force: :cascade do |t|
    t.string   "title"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "submissions", force: :cascade do |t|
    t.string   "title"
    t.boolean  "adult"
    t.integer  "file_id"
    t.integer  "pool_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "uploads", force: :cascade do |t|
    t.string   "file"
    t.boolean  "enabled",           default: true
    t.boolean  "explicit",          default: false
    t.string   "md5"
    t.string   "original_filename"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "password_digest"
    t.string   "email"
    t.string   "level"
    t.inet     "ip_address"
    t.string   "gallery"
    t.string   "price"
    t.text     "details"
    t.integer  "statuses",          default: [0, 0, 0, 0],              array: true
    t.string   "tags"
    t.string   "string"
    t.tsvector "tags_tsvector"
    t.integer  "avatar"
    t.boolean  "view_adult",        default: false
    t.string   "activation_digest"
    t.datetime "activated_at"
    t.datetime "reset_sent_at"
    t.integer  "watching",          default: [],                        array: true
    t.string   "artist_type"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "favs",              default: [],                        array: true
  end

  add_index "users", ["tags_tsvector"], name: "index_users_on_tags_tsvector", using: :gin

end
