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

ActiveRecord::Schema.define(version: 2019_01_21_143835) do

  create_table "areas", force: :cascade do |t|
    t.string "name"
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "assessments", force: :cascade do |t|
    t.integer "group_id"
    t.integer "test_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_assessments_on_group_id"
    t.index ["test_id"], name: "index_assessments_on_test_id"
  end

  create_table "competences", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "area_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["area_id"], name: "index_competences_on_area_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "label"
    t.integer "user_id"
    t.boolean "archive", default: false
    t.boolean "demo", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_groups_on_user_id"
  end

  create_table "items", force: :cascade do |t|
    t.integer "test_id"
    t.string "shorthand"
    t.string "description"
    t.string "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["test_id"], name: "index_items_on_test_id"
  end

  create_table "results", force: :cascade do |t|
    t.integer "student_id"
    t.integer "assessment_id"
    t.integer "prior_result_id"
    t.date "test_date"
    t.date "test_week"
    t.date "expires_on"
    t.string "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assessment_id"], name: "index_results_on_assessment_id"
    t.index ["prior_result_id"], name: "index_results_on_prior_result_id"
    t.index ["student_id"], name: "index_results_on_student_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "name"
    t.string "login"
    t.integer "group_id"
    t.integer "gender"
    t.date "birthmonth"
    t.integer "sen"
    t.boolean "migration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_students_on_group_id"
  end

  create_table "test_families", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "competence_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["competence_id"], name: "index_test_families_on_competence_id"
  end

  create_table "tests", force: :cascade do |t|
    t.integer "test_family_id"
    t.string "level"
    t.string "shorthand"
    t.string "description"
    t.boolean "student_test"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["test_family_id"], name: "index_tests_on_test_family_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "security_digest"
    t.string "capabilities"
    t.datetime "last_login"
    t.integer "account_type"
    t.integer "state"
    t.integer "institution"
    t.string "town"
    t.integer "school_type"
    t.integer "focus"
    t.datetime "tc_accepted"
    t.integer "intro_state", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
