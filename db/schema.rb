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

ActiveRecord::Schema.define(version: 20160502140628) do

  create_table "addresses", force: :cascade do |t|
    t.integer  "addressable_id",   limit: 4
    t.string   "addressable_type", limit: 255
    t.string   "street",           limit: 255
    t.string   "city",             limit: 255
    t.integer  "zipcode",          limit: 4
    t.integer  "state_id",         limit: 4
    t.integer  "country_id",       limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "limo_companies", force: :cascade do |t|
    t.string   "uid",                    limit: 255
    t.string   "name",                   limit: 255
    t.string   "logo",                   limit: 255
    t.string   "email",                  limit: 255
    t.string   "primary_phone_number",   limit: 255
    t.string   "secondary_phone_number", limit: 255
    t.string   "fax",                    limit: 255
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name",            limit: 255
    t.string   "last_name",             limit: 255
    t.string   "user_name",             limit: 255
    t.string   "password",              limit: 255
    t.string   "mobile_number",         limit: 255
    t.string   "auth_token",            limit: 255
    t.datetime "auth_token_expires_at"
    t.integer  "limo_company_id",       limit: 4
    t.integer  "role_id",               limit: 4
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

end
