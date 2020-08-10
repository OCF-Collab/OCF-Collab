# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_08_10_024350) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "node_competencies", force: :cascade do |t|
    t.bigint "node_framework_id"
    t.string "reference_id"
    t.string "text"
    t.string "comment"
    t.json "payload"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["node_framework_id"], name: "index_node_competencies_on_node_framework_id"
  end

  create_table "node_directories", force: :cascade do |t|
    t.string "uuid"
    t.string "reference_id"
    t.json "payload"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
  end

  create_table "node_frameworks", force: :cascade do |t|
    t.bigint "node_directory_id"
    t.string "uuid"
    t.string "reference_id"
    t.string "name"
    t.text "description"
    t.json "payload"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["node_directory_id"], name: "index_node_frameworks_on_node_directory_id"
  end

  create_table "registry_directories", force: :cascade do |t|
    t.string "uuid"
    t.string "reference_id"
    t.json "payload"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "registry_entries", force: :cascade do |t|
    t.string "name"
    t.string "uuid"
    t.string "reference_id"
    t.text "description"
    t.json "payload"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "registry_directory_id"
    t.index ["registry_directory_id"], name: "index_registry_entries_on_registry_directory_id"
  end

end
