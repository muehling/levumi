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

ActiveRecord::Schema.define(version: 20180125094454) do

  create_table "answers", force: :cascade do |t|
    t.integer  "question_id"
    t.text     "text"
    t.text     "short_text"
    t.text     "help_text"
    t.integer  "weight"
    t.string   "response_class"
    t.string   "reference_identifier"
    t.string   "data_export_identifier"
    t.string   "common_namespace"
    t.string   "common_identifier"
    t.integer  "display_order"
    t.boolean  "is_exclusive"
    t.integer  "display_length"
    t.string   "custom_class"
    t.string   "custom_renderer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "default_value"
    t.string   "api_id"
    t.string   "display_type"
    t.string   "input_mask"
    t.string   "input_mask_placeholder"
    t.index ["api_id"], name: "uq_answers_api_id", unique: true
  end

  create_table "assessments", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "test_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dependencies", force: :cascade do |t|
    t.integer  "question_id"
    t.integer  "question_group_id"
    t.string   "rule"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dependency_conditions", force: :cascade do |t|
    t.integer  "dependency_id"
    t.string   "rule_key"
    t.integer  "question_id"
    t.string   "operator"
    t.integer  "answer_id"
    t.datetime "datetime_value"
    t.integer  "integer_value"
    t.float    "float_value"
    t.string   "unit"
    t.text     "text_value"
    t.string   "string_value"
    t.string   "response_other"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "faqs", force: :cascade do |t|
    t.text     "question"
    t.text     "response"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", force: :cascade do |t|
    t.text     "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "archive"
    t.boolean  "export"
    t.boolean  "demo"
  end

  create_table "items", force: :cascade do |t|
    t.integer  "test_id"
    t.text     "shorthand"
    t.text     "itemtext"
    t.integer  "difficulty"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "mediapath"
    t.text     "itemview"
    t.integer  "itemtype"
  end

  create_table "materials", force: :cascade do |t|
    t.text     "subject"
    t.text     "construct"
    t.text     "block"
    t.text     "exercisetype"
    t.text     "blockinfo"
    t.text     "exerciseinfo"
    t.text     "data"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "materials_tests", id: false, force: :cascade do |t|
    t.integer "material_id"
    t.integer "test_id"
  end

  create_table "measurements", force: :cascade do |t|
    t.integer  "assessment_id"
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news", force: :cascade do |t|
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "question_groups", force: :cascade do |t|
    t.text     "text"
    t.text     "help_text"
    t.string   "reference_identifier"
    t.string   "data_export_identifier"
    t.string   "common_namespace"
    t.string   "common_identifier"
    t.string   "display_type"
    t.string   "custom_class"
    t.string   "custom_renderer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "api_id"
    t.index ["api_id"], name: "uq_question_groups_api_id", unique: true
  end

  create_table "questions", force: :cascade do |t|
    t.integer  "survey_section_id"
    t.integer  "question_group_id"
    t.text     "text"
    t.text     "short_text"
    t.text     "help_text"
    t.string   "pick"
    t.string   "reference_identifier"
    t.string   "data_export_identifier"
    t.string   "common_namespace"
    t.string   "common_identifier"
    t.integer  "display_order"
    t.string   "display_type"
    t.boolean  "is_mandatory"
    t.integer  "display_width"
    t.string   "custom_class"
    t.string   "custom_renderer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "correct_answer_id"
    t.string   "api_id"
    t.index ["api_id"], name: "uq_questions_api_id", unique: true
  end

  create_table "response_sets", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "survey_id"
    t.string   "access_code"
    t.datetime "started_at"
    t.datetime "completed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "api_id"
    t.index ["access_code"], name: "response_sets_ac_idx", unique: true
    t.index ["api_id"], name: "uq_response_sets_api_id", unique: true
  end

  create_table "responses", force: :cascade do |t|
    t.integer  "response_set_id"
    t.integer  "question_id"
    t.integer  "answer_id"
    t.datetime "datetime_value"
    t.integer  "integer_value"
    t.float    "float_value"
    t.string   "unit"
    t.text     "text_value"
    t.string   "string_value"
    t.string   "response_other"
    t.string   "response_group"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "survey_section_id"
    t.string   "api_id"
    t.index ["api_id"], name: "uq_responses_api_id", unique: true
    t.index ["survey_section_id"], name: "index_responses_on_survey_section_id"
  end

  create_table "results", force: :cascade do |t|
    t.integer  "student_id"
    t.integer  "measurement_id"
    t.text     "items"
    t.text     "responses"
    t.float    "total"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "extra_data"
  end

  create_table "students", force: :cascade do |t|
    t.text     "name"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "birthdate"
    t.boolean  "gender"
    t.integer  "specific_needs"
    t.boolean  "migration"
    t.text     "login"
  end

  create_table "survey_sections", force: :cascade do |t|
    t.integer  "survey_id"
    t.string   "title"
    t.text     "description"
    t.string   "reference_identifier"
    t.string   "data_export_identifier"
    t.string   "common_namespace"
    t.string   "common_identifier"
    t.integer  "display_order"
    t.string   "custom_class"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "survey_translations", force: :cascade do |t|
    t.integer  "survey_id"
    t.string   "locale"
    t.text     "translation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "surveys", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "access_code"
    t.string   "reference_identifier"
    t.string   "data_export_identifier"
    t.string   "common_namespace"
    t.string   "common_identifier"
    t.datetime "active_at"
    t.datetime "inactive_at"
    t.string   "css_url"
    t.string   "custom_class"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "display_order"
    t.string   "api_id"
    t.integer  "survey_version",         default: 0
    t.index ["access_code", "survey_version"], name: "surveys_access_code_version_idx", unique: true
    t.index ["api_id"], name: "uq_surveys_api_id", unique: true
  end

  create_table "tests", force: :cascade do |t|
    t.text     "name"
    t.text     "info"
    t.integer  "len"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "type"
    t.integer  "time"
    t.text     "short_info"
    t.text     "subject"
    t.text     "construct"
    t.text     "level"
    t.text     "answers"
    t.boolean  "student_access"
    t.boolean  "archive"
    t.text     "type_info"
    t.string   "shorthand"
  end

  create_table "users", force: :cascade do |t|
    t.text     "email"
    t.text     "password_digest"
    t.text     "name"
    t.text     "school"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "capabilities"
    t.datetime "tcaccept"
    t.datetime "last_login"
    t.integer  "account_type"
    t.integer  "state"
    t.integer  "occupation"
  end

  create_table "validation_conditions", force: :cascade do |t|
    t.integer  "validation_id"
    t.string   "rule_key"
    t.string   "operator"
    t.integer  "question_id"
    t.integer  "answer_id"
    t.datetime "datetime_value"
    t.integer  "integer_value"
    t.float    "float_value"
    t.string   "unit"
    t.text     "text_value"
    t.string   "string_value"
    t.string   "response_other"
    t.string   "regexp"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "validations", force: :cascade do |t|
    t.integer  "answer_id"
    t.string   "rule"
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
