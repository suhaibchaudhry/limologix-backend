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

ActiveRecord::Schema.define(version: 20160505124016) do

  create_table "addresses", force: :cascade do |t|
    t.integer  "addressable_id",   limit: 4
    t.string   "addressable_type", limit: 255
    t.string   "street",           limit: 255
    t.string   "city",             limit: 255
    t.integer  "zipcode",          limit: 4
    t.string   "state_code",       limit: 255
    t.string   "country_code",     limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "addresses", ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable_type_and_addressable_id", using: :btree

  create_table "drivers", force: :cascade do |t|
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.string   "password",               limit: 255
    t.string   "email",                  limit: 255
    t.string   "mobile_number",          limit: 255
    t.string   "user_name",              limit: 255
    t.date     "dob"
    t.string   "home_phone_number",      limit: 255
    t.string   "fax_number",             limit: 255
    t.string   "social_security_number", limit: 255
    t.string   "display_name",           limit: 255
    t.string   "license_number",         limit: 255
    t.string   "license_image",          limit: 255
    t.string   "license_expiry_date",    limit: 255
    t.string   "badge_number",           limit: 255
    t.string   "badge_expiry_date",      limit: 255
    t.string   "ara_number",             limit: 255
    t.string   "ara_image",              limit: 255
    t.string   "ara_exp_date",           limit: 255
    t.string   "auth_token",             limit: 255
    t.datetime "auth_token_expires_at"
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
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

  add_index "limo_companies", ["email"], name: "index_limo_companies_on_email", unique: true, using: :btree
  add_index "limo_companies", ["uid"], name: "index_limo_companies_on_uid", unique: true, using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "trips", force: :cascade do |t|
    t.string   "start_destination", limit: 255
    t.string   "end_destination",   limit: 255
    t.datetime "pick_up_at"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.string   "user_name",              limit: 255
    t.string   "password",               limit: 255
    t.string   "email",                  limit: 255
    t.string   "mobile_number",          limit: 255
    t.string   "auth_token",             limit: 255
    t.datetime "auth_token_expires_at"
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.integer  "limo_company_id",        limit: 4
    t.integer  "role_id",                limit: 4
    t.integer  "admin_id",               limit: 4
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "users", ["admin_id"], name: "index_users_on_admin_id", using: :btree
  add_index "users", ["auth_token"], name: "index_users_on_auth_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["limo_company_id"], name: "index_users_on_limo_company_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["role_id"], name: "index_users_on_role_id", using: :btree
  add_index "users", ["user_name"], name: "index_users_on_user_name", unique: true, using: :btree

  create_table "vehicle_models", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.integer  "vehicle_type_id", limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "vehicle_models", ["vehicle_type_id"], name: "index_vehicle_models_on_vehicle_type_id", using: :btree

  create_table "vehicle_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "vehicles", force: :cascade do |t|
    t.string   "color",                limit: 255
    t.string   "hll_number",           limit: 255
    t.string   "license_plate_number", limit: 255
    t.string   "year_of_purchase",     limit: 255
    t.integer  "owner_id",             limit: 4
    t.string   "owner_type",           limit: 255
    t.integer  "vehicle_model_id",     limit: 4
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "vehicles", ["owner_type", "owner_id"], name: "index_vehicles_on_owner_type_and_owner_id", using: :btree
  add_index "vehicles", ["vehicle_model_id"], name: "index_vehicles_on_vehicle_model_id", using: :btree

end
