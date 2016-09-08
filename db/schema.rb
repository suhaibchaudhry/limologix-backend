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

ActiveRecord::Schema.define(version: 20160907083532) do

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

  create_table "advertisements", force: :cascade do |t|
    t.string   "poster",     limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "companies", force: :cascade do |t|
    t.string   "uid",                    limit: 255
    t.string   "name",                   limit: 255
    t.string   "logo",                   limit: 255
    t.string   "email",                  limit: 255
    t.string   "primary_phone_number",   limit: 255
    t.string   "secondary_phone_number", limit: 255
    t.string   "channel",                limit: 255
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

  create_table "dispatches", force: :cascade do |t|
    t.integer  "driver_id",  limit: 4
    t.integer  "trip_id",    limit: 4
    t.datetime "started_at"
    t.datetime "ended_at"
    t.string   "status",     limit: 255, default: "yet_to_start"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "dispatches", ["driver_id"], name: "index_dispatches_on_driver_id", using: :btree
  add_index "dispatches", ["trip_id"], name: "index_dispatches_on_trip_id", using: :btree

  create_table "driver_groups", force: :cascade do |t|
    t.integer  "driver_id",  limit: 4
    t.integer  "group_id",   limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "driver_groups", ["driver_id"], name: "index_driver_groups_on_driver_id", using: :btree
  add_index "driver_groups", ["group_id"], name: "index_driver_groups_on_group_id", using: :btree

  create_table "drivers", force: :cascade do |t|
    t.string   "first_name",                  limit: 255
    t.string   "last_name",                   limit: 255
    t.string   "password",                    limit: 255
    t.string   "email",                       limit: 255
    t.string   "company",                     limit: 255
    t.string   "mobile_number",               limit: 255
    t.string   "auth_token",                  limit: 255
    t.datetime "auth_token_expires_at"
    t.string   "reset_password_token",        limit: 255
    t.datetime "reset_password_sent_at"
    t.boolean  "visible",                                 default: false
    t.string   "license_number",              limit: 255
    t.string   "license_image",               limit: 255
    t.date     "license_expiry_date"
    t.string   "badge_number",                limit: 255
    t.date     "badge_expiry_date"
    t.string   "ara_image",                   limit: 255
    t.date     "ara_expiry_date"
    t.string   "insurance_company",           limit: 255
    t.string   "insurance_policy_number",     limit: 255
    t.date     "insurance_expiry_date"
    t.string   "merchant_id",                 limit: 255
    t.string   "customer_profile_id",         limit: 255
    t.string   "customer_payment_profile_id", limit: 255
    t.integer  "toll_credit",                 limit: 4,   default: 0
    t.string   "status",                      limit: 255, default: "pending"
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
  end

  add_index "drivers", ["auth_token"], name: "index_drivers_on_auth_token", unique: true, using: :btree
  add_index "drivers", ["email"], name: "index_drivers_on_email", unique: true, using: :btree
  add_index "drivers", ["merchant_id"], name: "index_drivers_on_merchant_id", unique: true, using: :btree
  add_index "drivers", ["reset_password_token"], name: "index_drivers_on_reset_password_token", unique: true, using: :btree

  create_table "geolocations", force: :cascade do |t|
    t.string   "place",          limit: 255
    t.decimal  "latitude",                   precision: 20, scale: 15
    t.decimal  "longitude",                  precision: 20, scale: 15
    t.string   "type",           limit: 255
    t.integer  "locatable_id",   limit: 4
    t.string   "locatable_type", limit: 255
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
  end

  add_index "geolocations", ["locatable_type", "locatable_id"], name: "index_geolocations_on_locatable_type_and_locatable_id", using: :btree

  create_table "groups", force: :cascade do |t|
    t.integer  "company_id",  limit: 4
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.string   "status",      limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "groups", ["company_id"], name: "index_groups_on_company_id", using: :btree

  create_table "mobile_notifications", force: :cascade do |t|
    t.string   "title",           limit: 255
    t.text     "body",            limit: 65535
    t.text     "data",            limit: 65535
    t.integer  "notifiable_id",   limit: 4
    t.string   "notifiable_type", limit: 255
    t.integer  "driver_id",       limit: 4
    t.string   "status",          limit: 255
    t.string   "response",        limit: 255
    t.string   "kind",            limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "mobile_notifications", ["driver_id"], name: "index_mobile_notifications_on_driver_id", using: :btree
  add_index "mobile_notifications", ["notifiable_type", "notifiable_id"], name: "index_mobile_notifications_on_notifiable_type_and_notifiable_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.integer  "driver_id",          limit: 4
    t.integer  "amount",             limit: 4
    t.string   "transaction_number", limit: 255
    t.boolean  "status",                         default: false
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  add_index "transactions", ["driver_id"], name: "index_transactions_on_driver_id", using: :btree

  create_table "trip_groups", force: :cascade do |t|
    t.integer  "trip_id",    limit: 4
    t.integer  "group_id",   limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "trip_groups", ["group_id"], name: "index_trip_groups_on_group_id", using: :btree
  add_index "trip_groups", ["trip_id"], name: "index_trip_groups_on_trip_id", using: :btree

  create_table "trips", force: :cascade do |t|
    t.datetime "pick_up_at"
    t.integer  "passengers_count", limit: 4
    t.integer  "user_id",          limit: 4
    t.integer  "customer_id",      limit: 4
    t.integer  "vehicle_type_id",  limit: 4
    t.string   "status",           limit: 255, default: "pending"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.float    "price",            limit: 24
  end

  add_index "trips", ["customer_id"], name: "index_trips_on_customer_id", using: :btree
  add_index "trips", ["user_id"], name: "index_trips_on_user_id", using: :btree
  add_index "trips", ["vehicle_type_id"], name: "index_trips_on_vehicle_type_id", using: :btree

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

  create_table "vehicle_features", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "vehicle_id", limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "vehicle_features", ["vehicle_id"], name: "index_vehicle_features_on_vehicle_id", using: :btree

  create_table "vehicle_make_types", force: :cascade do |t|
    t.integer  "vehicle_type_id", limit: 4
    t.integer  "vehicle_make_id", limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "vehicle_make_types", ["vehicle_make_id"], name: "index_vehicle_make_types_on_vehicle_make_id", using: :btree
  add_index "vehicle_make_types", ["vehicle_type_id"], name: "index_vehicle_make_types_on_vehicle_type_id", using: :btree

  create_table "vehicle_makes", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "vehicle_models", force: :cascade do |t|
    t.string   "name",                 limit: 255
    t.integer  "vehicle_make_type_id", limit: 4
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "vehicle_models", ["vehicle_make_type_id"], name: "index_vehicle_models_on_vehicle_make_type_id", using: :btree

  create_table "vehicle_types", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.integer  "capacity",    limit: 4
    t.string   "image",       limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "vehicles", force: :cascade do |t|
    t.string   "color",                limit: 255
    t.string   "hll_number",           limit: 255
    t.string   "license_plate_number", limit: 255
    t.integer  "driver_id",            limit: 4
    t.integer  "vehicle_type_id",      limit: 4
    t.integer  "vehicle_model_id",     limit: 4
    t.integer  "vehicle_make_id",      limit: 4
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "vehicles", ["driver_id"], name: "index_vehicles_on_driver_id", using: :btree
  add_index "vehicles", ["vehicle_make_id"], name: "index_vehicles_on_vehicle_make_id", using: :btree
  add_index "vehicles", ["vehicle_model_id"], name: "index_vehicles_on_vehicle_model_id", using: :btree
  add_index "vehicles", ["vehicle_type_id"], name: "index_vehicles_on_vehicle_type_id", using: :btree

  create_table "web_notifications", force: :cascade do |t|
    t.text     "message",          limit: 65535
    t.integer  "notifiable_id",    limit: 4
    t.string   "notifiable_type",  limit: 255
    t.integer  "publishable_id",   limit: 4
    t.string   "publishable_type", limit: 255
    t.boolean  "read_status"
    t.string   "response_status",  limit: 255
    t.string   "kind",             limit: 255
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "web_notifications", ["notifiable_type", "notifiable_id"], name: "index_web_notifications_on_notifiable_type_and_notifiable_id", using: :btree
  add_index "web_notifications", ["publishable_type", "publishable_id"], name: "index_web_notifications_on_publishable_type_and_publishable_id", using: :btree

end
