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

ActiveRecord::Schema[7.0].define(version: 2022_07_21_080259) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.integer "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", precision: nil, null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.integer "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "annotations", force: :cascade do |t|
    t.integer "assessment_id"
    t.integer "student_id"
    t.integer "group_id"
    t.integer "view"
    t.text "content"
    t.date "start"
    t.date "end"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["assessment_id"], name: "index_annotations_on_assessment_id"
    t.index ["group_id"], name: "index_annotations_on_group_id"
    t.index ["student_id"], name: "index_annotations_on_student_id"
  end

  create_table "areas", force: :cascade do |t|
    t.string "name"
    t.string "color"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "assessments", force: :cascade do |t|
    t.integer "group_id"
    t.integer "test_id"
    t.boolean "active", default: true
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.json "excludes"
    t.index ["group_id"], name: "index_assessments_on_group_id"
    t.index ["test_id"], name: "index_assessments_on_test_id"
  end

  create_table "competences", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "area_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["area_id"], name: "index_competences_on_area_id"
  end

  create_table "group_shares", force: :cascade do |t|
    t.boolean "owner"
    t.boolean "read_only"
    t.string "key"
    t.integer "user_id"
    t.integer "group_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["group_id"], name: "index_group_shares_on_group_id"
    t.index ["user_id"], name: "index_group_shares_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "label"
    t.boolean "archive", default: false
    t.boolean "demo", default: false
    t.string "auth_token"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "material_supports", force: :cascade do |t|
    t.integer "material_id"
    t.integer "area_id"
    t.integer "competence_id"
    t.integer "test_family_id"
    t.integer "test_id"
    t.json "items"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["area_id"], name: "index_material_supports_on_area_id"
    t.index ["competence_id"], name: "index_material_supports_on_competence_id"
    t.index ["material_id"], name: "index_material_supports_on_material_id"
    t.index ["test_family_id"], name: "index_material_supports_on_test_family_id"
    t.index ["test_id"], name: "index_material_supports_on_test_id"
  end

  create_table "materials", force: :cascade do |t|
    t.string "name"
    t.json "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "results", force: :cascade do |t|
    t.integer "student_id"
    t.integer "assessment_id"
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

  create_table "shadow_results", force: :cascade do |t|
    t.integer "shadow_student_id"
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

  create_table "shadow_students", force: :cascade do |t|
    t.integer "original_id"
    t.integer "group"
    t.integer "account_type"
    t.integer "state"
    t.integer "gender"
    t.date "birthmonth"
    t.integer "sen"
    t.json "tags"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["original_id"], name: "index_shadow_students_on_original_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "name"
    t.string "login"
    t.integer "group_id"
    t.integer "gender"
    t.date "birthmonth"
    t.integer "sen"
    t.json "tags"
    t.json "settings"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["group_id"], name: "index_students_on_group_id"
  end

  create_table "test_families", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "competence_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["competence_id"], name: "index_test_families_on_competence_id"
  end

  create_table "tests", force: :cascade do |t|
    t.integer "test_family_id"
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
    t.index ["test_family_id"], name: "index_tests_on_test_family_id"
  end

  create_table "users", force: :cascade do |t|
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
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
