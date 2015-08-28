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

ActiveRecord::Schema.define(version: 20150828104849) do

  create_table "assessments", force: true do |t|
    t.integer  "group_id"
    t.integer  "test_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", force: true do |t|
    t.text     "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "archive"
  end

  create_table "items", force: true do |t|
    t.integer  "test_id"
    t.text     "shorthand"
    t.text     "itemtext"
    t.integer  "difficulty"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "measurements", force: true do |t|
    t.integer  "assessment_id"
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "results", force: true do |t|
    t.integer  "student_id"
    t.integer  "measurement_id"
    t.text     "results"
    t.float    "total"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "students", force: true do |t|
    t.text     "firstname"
    t.text     "name"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tests", force: true do |t|
    t.text     "name"
    t.text     "info"
    t.integer  "len"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "type"
    t.integer  "time"
  end

  create_table "users", force: true do |t|
    t.text     "email"
    t.text     "password_digest"
    t.text     "name"
    t.text     "school"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
