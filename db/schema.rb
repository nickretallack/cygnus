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

ActiveRecord::Schema.define(version: 20161016021154) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bids", force: :cascade do |t|
    t.integer  "slot_id"
    t.integer  "user_id"
    t.string   "body"
    t.decimal  "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "bids", ["slot_id"], name: "index_bids_on_slot_id", using: :btree
  add_index "bids", ["user_id"], name: "index_bids_on_user_id", using: :btree

  create_table "cards", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "attachments", default: [],              array: true
  end

  create_table "comments", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "submission_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "images", force: :cascade do |t|
    t.string   "file"
    t.boolean  "enabled",           default: true
    t.boolean  "explicit",          default: false
    t.string   "md5"
    t.string   "original_filename"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "messages", force: :cascade do |t|
    t.string   "subject"
    t.text     "content"
    t.integer  "recipient_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "attachments",  default: [],              array: true
  end

  create_table "order_forms", force: :cascade do |t|
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "title"
    t.json     "content",    default: []
  end

  create_table "orders", force: :cascade do |t|
    t.json     "content",    default: []
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "decided",    default: false
    t.boolean  "accepted",   default: false
    t.string   "name"
    t.string   "email"
  end

  create_table "pools", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "attachments", default: [],              array: true
  end

  create_table "requests", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "upload_id"
    t.integer  "user_id"
    t.string   "breed",          null: false
    t.decimal  "max_price"
    t.integer  "auction_length", null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "requests", ["user_id"], name: "index_requests_on_user_id", using: :btree

  create_table "slots", force: :cascade do |t|
    t.string   "title"
    t.integer  "request_id"
    t.text     "body"
    t.decimal  "min_bid"
    t.decimal  "auto_buy"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "slots", ["request_id"], name: "index_slots_on_request_id", using: :btree

  create_table "submissions", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.text     "description"
    t.string   "attachments", default: [],                array: true
    t.boolean  "hidden",      default: true
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "password_digest"
    t.string   "email"
    t.string   "level"
    t.inet     "ip_address"
    t.string   "price"
    t.text     "details"
    t.string   "tags"
    t.tsvector "tags_tsvector"
    t.string   "activation_digest"
    t.datetime "activated_at"
    t.datetime "reset_sent_at"
    t.integer  "watching",          default: [],                                                                                    array: true
    t.datetime "created_at",                                                                                           null: false
    t.datetime "updated_at",                                                                                           null: false
    t.integer  "favs",              default: [],                                                                                    array: true
    t.string   "statuses",          default: ["not_interested", "not_interested", "not_interested", "not_interested"],              array: true
    t.string   "attachments",       default: [],                                                                                    array: true
    t.json     "settings",          default: {}
    t.string   "artist_types",      default: [],                                                                                    array: true
    t.string   "offsite_galleries", default: [],                                                                                    array: true
  end

  add_index "users", ["tags_tsvector"], name: "index_users_on_tags_tsvector", using: :gin

  add_foreign_key "bids", "slots"
  add_foreign_key "bids", "users"
  add_foreign_key "requests", "users"
  add_foreign_key "slots", "requests"
end
