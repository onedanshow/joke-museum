# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_07_30_185609) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "plpgsql"

  create_table "jokes", force: :cascade do |t|
    t.text "setup"
    t.text "punchline"
    t.integer "joke_type", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "source_id"
  end

  create_table "jokes_pages", id: false, force: :cascade do |t|
    t.bigint "joke_id", null: false
    t.bigint "page_id", null: false
    t.index ["joke_id", "page_id"], name: "index_jokes_pages_on_joke_id_and_page_id_uniq", unique: true
    t.index ["page_id", "joke_id"], name: "index_jokes_pages_on_page_id_and_joke_id_uniq", unique: true
  end

  create_table "page_relations", force: :cascade do |t|
    t.bigint "page_id", null: false
    t.bigint "related_page_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_id", "related_page_id"], name: "index_page_relations_on_page_id_and_related_page_id", unique: true
    t.index ["page_id"], name: "index_page_relations_on_page_id"
    t.index ["related_page_id"], name: "index_page_relations_on_related_page_id"
  end

  create_table "pages", force: :cascade do |t|
    t.citext "keywords", null: false
    t.bigint "shopify_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "excluded_joke_ids", default: [], array: true
    t.string "handle"
    t.index ["handle"], name: "index_pages_on_handle", unique: true
    t.index ["keywords"], name: "index_pages_on_keywords", unique: true
  end

  create_table "sources", force: :cascade do |t|
    t.text "url"
    t.string "filename"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "page_relations", "pages"
  add_foreign_key "page_relations", "pages", column: "related_page_id"
end
