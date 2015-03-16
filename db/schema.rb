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

ActiveRecord::Schema.define(version: 20150314055927) do

  create_table "branches", force: :cascade do |t|
    t.text     "description"
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "phone"
    t.integer  "store_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "branches_promos", id: false, force: :cascade do |t|
    t.integer "promo_id"
    t.integer "branch_id"
  end

  add_index "branches_promos", ["branch_id"], name: "index_branches_promos_on_branch_id"
  add_index "branches_promos", ["promo_id"], name: "index_branches_promos_on_promo_id"

  create_table "promos", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.text     "terms"
    t.datetime "expiration_date"
    t.integer  "people_limit"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "redemptions", force: :cascade do |t|
    t.string   "code"
    t.integer  "promo_id"
    t.integer  "user_id"
    t.boolean  "redeemed",   default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "stores", force: :cascade do |t|
    t.string   "email"
    t.string   "name"
    t.string   "category"
    t.string   "main_phone"
    t.string   "password"
    t.string   "salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "name"
    t.boolean  "gender"
    t.date     "birthday"
    t.string   "password"
    t.string   "salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
