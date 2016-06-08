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

ActiveRecord::Schema.define(version: 20160519080303) do

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

  create_table "companies", force: :cascade do |t|
    t.string   "uid",                    limit: 255
    t.string   "name",                   limit: 255
    t.string   "logo",                   limit: 255
    t.string   "email",                  limit: 255
    t.string   "primary_phone_number",   limit: 255
    t.string   "secondary_phone_number", limit: 255
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "companies", ["email"], name: "index_companies_on_email", unique: true, using: :btree
  add_index "companies", ["uid"], name: "index_companies_on_uid", unique: true, using: :btree

  create_table "customers", force: :cascade do |t|
    t.string   "first_name",    limit: 255
    t.string   "last_name",     limit: 255
    t.string   "email",         limit: 255
    t.string   "mobile_number", limit: 255
    t.string   "organisation",  limit: 255
    t.integer  "user_id",       limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "customers", ["user_id"], name: "index_customers_on_user_id", using: :btree

  create_table "drivers", force: :cascade do |t|
    t.string   "first_name",              limit: 255
    t.string   "last_name",               limit: 255
    t.string   "password",                limit: 255
    t.string   "email",                   limit: 255
    t.string   "mobile_number",           limit: 255
    t.date     "dob"
    t.string   "home_phone_number",       limit: 255
    t.string   "social_security_number",  limit: 255
    t.string   "display_name",            limit: 255
    t.string   "auth_token",              limit: 255
    t.datetime "auth_token_expires_at"
    t.string   "reset_password_token",    limit: 255
    t.datetime "reset_password_sent_at"
    t.boolean  "available",                           default: true
    t.string   "company",                 limit: 255
    t.string   "license_number",          limit: 255
    t.string   "license_image",           limit: 255
    t.date     "license_expiry_date"
    t.string   "badge_number",            limit: 255
    t.date     "badge_expiry_date"
    t.string   "ara_number",              limit: 255
    t.string   "ara_image",               limit: 255
    t.date     "ara_expiry_date"
    t.string   "insurance_company",       limit: 255
    t.string   "insurance_policy_number", limit: 255
    t.date     "insurance_expiry_date"
  end

  add_index "drivers", ["auth_token"], name: "index_drivers_on_auth_token", unique: true, using: :btree
  add_index "drivers", ["email"], name: "index_drivers_on_email", unique: true, using: :btree
  add_index "drivers", ["reset_password_token"], name: "index_drivers_on_reset_password_token", unique: true, using: :btree

  create_table "geolocations", force: :cascade do |t|
    t.string   "place",          limit: 255
    t.string   "latitude",       limit: 255
    t.string   "longitude",      limit: 255
    t.string   "type",           limit: 255
    t.integer  "locatable_id",   limit: 4
    t.string   "locatable_type", limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "geolocations", ["locatable_type", "locatable_id"], name: "index_geolocations_on_locatable_type_and_locatable_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "trips", force: :cascade do |t|
    t.datetime "pick_up_at"
    t.integer  "passengers_count", limit: 4
    t.integer  "user_id",          limit: 4
    t.integer  "customer_id",      limit: 4
    t.string   "status",           limit: 255, default: "pending"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
  end

  add_index "trips", ["customer_id"], name: "index_trips_on_customer_id", using: :btree
  add_index "trips", ["user_id"], name: "index_trips_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.string   "password",               limit: 255
    t.string   "email",                  limit: 255
    t.string   "mobile_number",          limit: 255
    t.string   "auth_token",             limit: 255
    t.datetime "auth_token_expires_at"
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.integer  "company_id",             limit: 4
    t.integer  "role_id",                limit: 4
    t.integer  "admin_id",               limit: 4
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "users", ["admin_id"], name: "index_users_on_admin_id", using: :btree
  add_index "users", ["auth_token"], name: "index_users_on_auth_token", unique: true, using: :btree
  add_index "users", ["company_id"], name: "index_users_on_company_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["role_id"], name: "index_users_on_role_id", using: :btree

  create_table "vehicle_types", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.integer  "capacity",    limit: 4
    t.string   "image",       limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "vehicles", force: :cascade do |t|
    t.string   "color",           limit: 255
    t.string   "make",            limit: 255
    t.string   "model",           limit: 255
    t.string   "hll",             limit: 255
    t.string   "license_plate",   limit: 255
    t.string   "features",        limit: 255
    t.integer  "driver_id",       limit: 4
    t.integer  "vehicle_type_id", limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "vehicles", ["driver_id"], name: "index_vehicles_on_driver_id", using: :btree
  add_index "vehicles", ["vehicle_type_id"], name: "index_vehicles_on_vehicle_type_id", using: :btree

end
