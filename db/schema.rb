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

ActiveRecord::Schema.define(version: 20150329225550) do

  create_table "uploads", force: :cascade do |t|
    t.string   "file"
    t.string   "ext"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "enabled",    default: true
    t.boolean  "explicit",   default: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "password_digest"
    t.string   "email"
    t.integer  "level",           default: 0
    t.inet     "ip_Address"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "gallery"
    t.string   "price"
    t.text     "details"
    t.boolean  "commissions"
    t.boolean  "trades"
    t.boolean  "requests"
    t.string   "tags"
    t.tsvector "tags_tsvector"
    t.integer  "avatar"
    t.boolean  "view_adult",      default: false
  end

  add_index "users", ["tags_tsvector"], name: "users_tags_search_idx", using: :gin

end
