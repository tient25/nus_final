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

ActiveRecord::Schema[8.1].define(version: 2025_11_12_091920) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "albums", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "likes_count"
    t.date "publication_date"
    t.boolean "sharing_mode"
    t.string "title"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_albums_on_user_id"
  end

  create_table "albums_photos", id: false, force: :cascade do |t|
    t.bigint "album_id", null: false
    t.bigint "photo_id", null: false
  end

  create_table "albums_users", id: false, force: :cascade do |t|
    t.bigint "album_id", null: false
    t.bigint "user_id", null: false
  end

  create_table "photos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.boolean "is_standalone"
    t.integer "likes_count"
    t.date "publication_date"
    t.boolean "sharing_mode"
    t.string "title"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_photos_on_user_id"
  end

  create_table "photos_users", id: false, force: :cascade do |t|
    t.bigint "photo_id", null: false
    t.bigint "user_id", null: false
  end

  create_table "users", force: :cascade do |t|
    t.boolean "active"
    t.string "avatar"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.string "password"
    t.boolean "role"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "albums", "users"
  add_foreign_key "photos", "users"
end
