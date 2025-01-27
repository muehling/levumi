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

ActiveRecord::Schema[7.2].define(version: 2025_01_27_114541) do
  create_table "active_storage_attachments", charset: "utf8mb3", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb3", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", precision: nil, null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "annotation_categories", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "annotations", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "assessment_id"
    t.bigint "student_id"
    t.bigint "group_id"
    t.text "view"
    t.date "start"
    t.date "end"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "annotation_category_id"
    t.index ["annotation_category_id"], name: "index_annotations_on_annotation_category_id"
    t.index ["assessment_id"], name: "index_annotations_on_assessment_id"
    t.index ["group_id"], name: "index_annotations_on_group_id"
    t.index ["student_id"], name: "index_annotations_on_student_id"
  end

  create_table "areas", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.string "color"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "assessments", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "group_id"
    t.bigint "test_id"
    t.boolean "active", default: true
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.json "excludes"
    t.json "settings"
    t.index ["group_id"], name: "index_assessments_on_group_id"
    t.index ["test_id"], name: "index_assessments_on_test_id"
  end

  create_table "competences", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "area_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["area_id"], name: "index_competences_on_area_id"
  end

  create_table "group_shares", charset: "utf8mb3", force: :cascade do |t|
    t.boolean "owner"
    t.boolean "read_only"
    t.string "key"
    t.bigint "user_id"
    t.bigint "group_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "is_anonymous"
    t.index ["group_id"], name: "index_group_shares_on_group_id"
    t.index ["user_id"], name: "index_group_shares_on_user_id"
  end

  create_table "groups", charset: "utf8mb3", force: :cascade do |t|
    t.string "label"
    t.boolean "archive", default: false
    t.boolean "demo", default: false
    t.string "auth_token"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.json "settings"
  end

  create_table "material_supports", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "material_id"
    t.bigint "area_id"
    t.bigint "competence_id"
    t.bigint "test_family_id"
    t.bigint "test_id"
    t.json "items"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "group"
    t.index ["area_id"], name: "index_material_supports_on_area_id"
    t.index ["competence_id"], name: "index_material_supports_on_competence_id"
    t.index ["material_id"], name: "index_material_supports_on_material_id"
    t.index ["test_family_id"], name: "index_material_supports_on_test_family_id"
    t.index ["test_id"], name: "index_material_supports_on_test_id"
  end

  create_table "materials", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.json "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "news", charset: "utf8mb3", force: :cascade do |t|
    t.date "date"
    t.string "title"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "results", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "student_id"
    t.bigint "assessment_id"
    t.date "test_date"
    t.date "test_week"
    t.json "views"
    t.json "report"
    t.json "data"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["assessment_id"], name: "index_results_on_assessment_id"
    t.index ["student_id"], name: "index_results_on_student_id"
  end

  create_table "shadow_results", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "shadow_student_id"
    t.string "shorthand"
    t.integer "version"
    t.integer "group"
    t.date "test_date"
    t.date "test_week"
    t.json "views"
    t.json "report"
    t.json "data"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["shadow_student_id"], name: "index_shadow_results_on_shadow_student_id"
  end

  create_table "shadow_students", charset: "utf8mb3", force: :cascade do |t|
    t.integer "original_id"
    t.integer "group"
    t.integer "account_type", null: false
    t.integer "state", null: false
    t.integer "gender"
    t.date "birthmonth"
    t.integer "sen"
    t.json "tags"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["original_id"], name: "index_shadow_students_on_original_id"
  end

  create_table "students", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.string "login"
    t.bigint "group_id"
    t.integer "gender"
    t.date "birthmonth"
    t.integer "sen"
    t.json "tags"
    t.json "settings"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["group_id"], name: "index_students_on_group_id"
  end

  create_table "support_messages", charset: "utf8mb3", force: :cascade do |t|
    t.string "subject"
    t.string "sender"
    t.text "message"
    t.integer "status"
    t.bigint "user_id"
    t.string "updated_by"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_support_messages_on_user_id"
  end

  create_table "targets", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "assessment_id"
    t.bigint "student_id"
    t.json "view"
    t.string "value"
    t.string "deviation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assessment_id"], name: "index_targets_on_assessment_id"
    t.index ["student_id"], name: "index_targets_on_student_id"
  end

  create_table "test_families", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "competence_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["competence_id"], name: "index_test_families_on_competence_id"
  end

  create_table "test_types", charset: "utf8mb3", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tests", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "test_family_id"
    t.string "level"
    t.string "shorthand"
    t.integer "version"
    t.json "description"
    t.boolean "student_test"
    t.boolean "archive", default: false
    t.json "configuration"
    t.json "items"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "test_type_id"
    t.string "updated_by"
    t.string "responsible"
    t.json "required_services"
    t.boolean "allow_quartiles", default: false
    t.index ["test_family_id"], name: "index_tests_on_test_family_id"
    t.index ["test_type_id"], name: "index_tests_on_test_type_id"
  end

  create_table "users", charset: "utf8mb3", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "security_digest"
    t.string "capabilities"
    t.datetime "last_login", precision: nil
    t.integer "account_type"
    t.integer "state"
    t.string "institution"
    t.string "town"
    t.integer "school_type"
    t.integer "focus"
    t.datetime "tc_accepted", precision: nil
    t.integer "intro_state", default: 0
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.json "settings"
    t.string "recovery_key"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "support_messages", "users"
  add_foreign_key "tests", "test_types"
end
