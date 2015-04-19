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

ActiveRecord::Schema.define(version: 20150419161128) do

  create_table "auths", force: :cascade do |t|
    t.string   "token",      limit: 255
    t.integer  "user_id",    limit: 4
    t.integer  "store_id",   limit: 4
    t.datetime "lifetime"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "branches", force: :cascade do |t|
    t.text     "name",       limit: 65535
    t.string   "address",    limit: 255
    t.float    "latitude",   limit: 24
    t.float    "longitude",  limit: 24
    t.string   "phone",      limit: 255
    t.integer  "store_id",   limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "branches_promos", id: false, force: :cascade do |t|
    t.integer "promo_id",  limit: 4
    t.integer "branch_id", limit: 4
  end

  add_index "branches_promos", ["branch_id"], name: "index_branches_promos_on_branch_id", using: :btree
  add_index "branches_promos", ["promo_id", "branch_id"], name: "index_branches_promos_on_promo_id_and_branch_id", unique: true, using: :btree
  add_index "branches_promos", ["promo_id"], name: "index_branches_promos_on_promo_id", using: :btree

  create_table "promos", force: :cascade do |t|
    t.string   "title",           limit: 255
    t.text     "description",     limit: 65535
    t.text     "terms",           limit: 65535
    t.datetime "expiration_date"
    t.integer  "people_limit",    limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "redemptions", force: :cascade do |t|
    t.string   "code",       limit: 255
    t.integer  "promo_id",   limit: 4
    t.integer  "user_id",    limit: 4
    t.boolean  "redeemed",   limit: 1,   default: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "stores", force: :cascade do |t|
    t.string   "email",      limit: 255
    t.string   "name",       limit: 255
    t.string   "category",   limit: 255
    t.string   "main_phone", limit: 255
    t.string   "password",   limit: 255
    t.string   "salt",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",      limit: 255
    t.string   "name",       limit: 255
    t.string   "gender",     limit: 255
    t.date     "birthday"
    t.string   "password",   limit: 255
    t.string   "salt",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

end
