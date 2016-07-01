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

ActiveRecord::Schema.define(version: 20160616102951) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"
  enable_extension "citext"

  create_table "service_settings", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "name"
    t.string   "token"
    t.string   "url"
    t.boolean  "listener"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_service_settings_on_name", unique: true, using: :btree
  end

  create_table "taggings", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "tag_id"
    t.uuid     "taggable_id"
    t.string   "taggable_type"
    t.string   "taggable_slug"
    t.datetime "created_at"
    t.index ["tag_id", "taggable_id", "taggable_type"], name: "taggings_index", unique: true, using: :btree
    t.index ["tag_id", "taggable_slug", "taggable_type"], name: "taggings_slug_index", unique: true, using: :btree
    t.index ["taggable_id", "taggable_type"], name: "index_taggings_on_taggable_id_and_taggable_type", using: :btree
  end

  create_table "tags", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "name"
    t.integer  "taggings_count", default: 0
    t.datetime "created_at"
    t.index ["name"], name: "index_tags_on_name", unique: true, using: :btree
  end

end
