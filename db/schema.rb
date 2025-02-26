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

ActiveRecord::Schema[8.0].define(version: 2025_02_26_185528) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "activities", force: :cascade do |t|
    t.string "trackable_type"
    t.bigint "trackable_id"
    t.string "owner_type"
    t.bigint "owner_id"
    t.string "key"
    t.text "parameters"
    t.string "recipient_type"
    t.bigint "recipient_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type"
    t.index ["owner_type", "owner_id"], name: "index_activities_on_owner"
    t.index ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type"
    t.index ["recipient_type", "recipient_id"], name: "index_activities_on_recipient"
    t.index ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type"
    t.index ["trackable_type", "trackable_id"], name: "index_activities_on_trackable"
  end

  create_table "attendee_vouchers", force: :cascade do |t|
    t.bigint "attendee_id"
    t.bigint "voucher_id"
    t.date "redeemed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attendee_id"], name: "index_attendee_vouchers_on_attendee_id"
    t.index ["voucher_id"], name: "index_attendee_vouchers_on_voucher_id"
  end

  create_table "attendees", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.integer "chuds_balance"
    t.string "seat_number"
    t.integer "performance_points"
    t.integer "level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "line_items", force: :cascade do |t|
    t.string "remote_order_id"
    t.string "remote_line_item_id"
    t.string "email"
    t.bigint "attendee_id"
    t.string "sku"
    t.bigint "performer_id"
    t.bigint "product_id"
    t.decimal "unit_price", precision: 10, scale: 2
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attendee_id"], name: "index_line_items_on_attendee_id"
    t.index ["email"], name: "index_line_items_on_email"
    t.index ["performer_id"], name: "index_line_items_on_performer_id"
    t.index ["product_id"], name: "index_line_items_on_product_id"
    t.index ["remote_line_item_id"], name: "index_line_items_on_remote_line_item_id"
    t.index ["remote_order_id"], name: "index_line_items_on_remote_order_id"
    t.index ["sku"], name: "index_line_items_on_sku"
  end

  create_table "payments", force: :cascade do |t|
    t.integer "amount", default: 1
    t.bigint "attendee_id", null: false
    t.bigint "performer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attendee_id"], name: "index_payments_on_attendee_id"
    t.index ["performer_id"], name: "index_payments_on_performer_id"
  end

  create_table "performers", force: :cascade do |t|
    t.string "name"
    t.integer "performance_points"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true
    t.integer "chuds_balance", default: 100
    t.decimal "commission_balance", precision: 10, scale: 2, default: "0.0"
    t.index ["active"], name: "index_performers_on_active"
  end

  create_table "products", force: :cascade do |t|
    t.integer "chuds"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "price", precision: 10, scale: 2
    t.string "name"
    t.string "availability"
    t.boolean "track_inventory"
    t.string "option_1"
    t.string "option_2"
    t.string "option_3"
  end

  create_table "settings", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.text "description"
    t.string "value_type"
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_settings_on_code"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "variants", force: :cascade do |t|
    t.boolean "parent"
    t.string "option_1"
    t.string "option_2"
    t.string "option_3"
    t.bigint "product_id"
    t.string "sku"
    t.integer "stock_level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent"], name: "index_variants_on_parent"
    t.index ["product_id"], name: "index_variants_on_product_id"
  end

  create_table "vouchers", force: :cascade do |t|
    t.string "code"
    t.integer "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "payments", "attendees"
  add_foreign_key "payments", "performers"
end
