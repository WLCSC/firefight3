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

ActiveRecord::Schema.define(version: 20150714143605) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alerts", force: :cascade do |t|
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.text     "content"
    t.datetime "trigger"
    t.json     "meta"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "user_sid"
  end

  add_index "alerts", ["attachable_type", "attachable_id"], name: "index_alerts_on_attachable_type_and_attachable_id", using: :btree

  create_table "assets", force: :cascade do |t|
    t.string   "tag"
    t.string   "vendor"
    t.json     "history"
    t.string   "serial"
    t.date     "purchase"
    t.integer  "cost"
    t.string   "name"
    t.string   "targetable_type"
    t.string   "targetable_id"
    t.integer  "model_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "assets", ["model_id"], name: "index_assets_on_model_id", using: :btree
  add_index "assets", ["tag"], name: "index_assets_on_tag", unique: true, using: :btree
  add_index "assets", ["vendor"], name: "index_assets_on_vendor", using: :btree

  create_table "assignments", force: :cascade do |t|
    t.string   "user_sid"
    t.integer  "building_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "assignments", ["building_id"], name: "index_assignments_on_building_id", using: :btree
  add_index "assignments", ["user_sid"], name: "index_assignments_on_user_sid", using: :btree

  create_table "attachments", force: :cascade do |t|
    t.string   "user_sid"
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  add_index "attachments", ["attachable_type", "attachable_id"], name: "index_attachments_on_attachable_type_and_attachable_id", using: :btree

  create_table "buildings", force: :cascade do |t|
    t.string   "name"
    t.string   "short"
    t.integer  "storeroom_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "buildings", ["name"], name: "index_buildings_on_name", unique: true, using: :btree
  add_index "buildings", ["short"], name: "index_buildings_on_short", unique: true, using: :btree
  add_index "buildings", ["storeroom_id"], name: "index_buildings_on_storeroom_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.text     "content"
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.string   "user_sid"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.boolean  "mod"
  end

  add_index "comments", ["attachable_type", "attachable_id"], name: "index_comments_on_attachable_type_and_attachable_id", using: :btree
  add_index "comments", ["user_sid"], name: "index_comments_on_user_sid", using: :btree

  create_table "consumables", force: :cascade do |t|
    t.string   "name"
    t.string   "short"
    t.string   "barcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "consumables", ["barcode"], name: "index_consumables_on_barcode", unique: true, using: :btree
  add_index "consumables", ["short"], name: "index_consumables_on_short", unique: true, using: :btree

  create_table "consumers", force: :cascade do |t|
    t.integer  "model_id"
    t.integer  "consumable_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "consumers", ["consumable_id"], name: "index_consumers_on_consumable_id", using: :btree
  add_index "consumers", ["model_id"], name: "index_consumers_on_model_id", using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "missions", force: :cascade do |t|
    t.integer  "ticket_id"
    t.string   "user_sid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "missions", ["ticket_id"], name: "index_missions_on_ticket_id", using: :btree
  add_index "missions", ["user_sid"], name: "index_missions_on_user_sid", using: :btree

  create_table "models", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "manufacturer"
    t.string   "category"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "models", ["category"], name: "index_models_on_category", using: :btree
  add_index "models", ["manufacturer"], name: "index_models_on_manufacturer", using: :btree
  add_index "models", ["name"], name: "index_models_on_name", unique: true, using: :btree
  add_index "models", ["slug"], name: "index_models_on_slug", unique: true, using: :btree

  create_table "permissions", force: :cascade do |t|
    t.string   "listable_sid"
    t.integer  "topic_id"
    t.integer  "level"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "permissions", ["listable_sid"], name: "index_permissions_on_listable_sid", using: :btree
  add_index "permissions", ["topic_id"], name: "index_permissions_on_topic_id", using: :btree

  create_table "rooms", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "slug"
    t.integer  "building_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "rooms", ["building_id"], name: "index_rooms_on_building_id", using: :btree
  add_index "rooms", ["name"], name: "index_rooms_on_name", using: :btree
  add_index "rooms", ["slug"], name: "index_rooms_on_slug", unique: true, using: :btree

  create_table "services", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.string   "description"
    t.integer  "service_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "services", ["name"], name: "index_services_on_name", unique: true, using: :btree
  add_index "services", ["service_id"], name: "index_services_on_service_id", using: :btree

  create_table "statuses", force: :cascade do |t|
    t.integer  "code"
    t.string   "note"
    t.integer  "service_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "statuses", ["service_id"], name: "index_statuses_on_service_id", using: :btree

  create_table "steps", force: :cascade do |t|
    t.integer  "ticket_id"
    t.text     "content"
    t.integer  "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stocks", force: :cascade do |t|
    t.integer  "count"
    t.integer  "consumable_id"
    t.integer  "room_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "stocks", ["consumable_id"], name: "index_stocks_on_consumable_id", using: :btree
  add_index "stocks", ["room_id"], name: "index_stocks_on_room_id", using: :btree

  create_table "subscriptions", force: :cascade do |t|
    t.string   "user_sid"
    t.integer  "subscribable_id"
    t.string   "subscribable_type"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "subscriptions", ["subscribable_type", "subscribable_id"], name: "index_subscriptions_on_subscribable_type_and_subscribable_id", using: :btree
  add_index "subscriptions", ["user_sid"], name: "index_subscriptions_on_user_sid", using: :btree

  create_table "targets", force: :cascade do |t|
    t.integer  "ticket_id"
    t.string   "targetable_type"
    t.string   "targetable_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "tickets", force: :cascade do |t|
    t.integer  "topic_id"
    t.string   "submitter_sid"
    t.datetime "due"
    t.integer  "status"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "tickets", ["submitter_sid"], name: "index_tickets_on_submitter_sid", using: :btree
  add_index "tickets", ["topic_id"], name: "index_tickets_on_topic_id", using: :btree

  create_table "topics", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "icon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "topics", ["slug"], name: "index_topics_on_slug", using: :btree

  create_table "uses", force: :cascade do |t|
    t.integer  "room_id"
    t.integer  "consumable_id"
    t.string   "attachable_type"
    t.string   "attachable_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "uses", ["consumable_id"], name: "index_uses_on_consumable_id", using: :btree
  add_index "uses", ["room_id"], name: "index_uses_on_room_id", using: :btree

  add_foreign_key "assets", "models"
  add_foreign_key "assignments", "buildings"
  add_foreign_key "buildings", "rooms", column: "storeroom_id"
  add_foreign_key "consumers", "consumables"
  add_foreign_key "consumers", "models"
  add_foreign_key "missions", "tickets"
  add_foreign_key "permissions", "topics"
  add_foreign_key "rooms", "buildings"
  add_foreign_key "services", "services"
  add_foreign_key "statuses", "services"
  add_foreign_key "stocks", "consumables"
  add_foreign_key "stocks", "rooms"
  add_foreign_key "tickets", "topics"
  add_foreign_key "uses", "consumables"
  add_foreign_key "uses", "rooms"
end
