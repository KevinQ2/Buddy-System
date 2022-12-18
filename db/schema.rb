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

ActiveRecord::Schema.define(version: 2021_04_08_130637) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.string "first_name"
    t.string "last_name"
    t.string "admin_access", default: [], array: true
    t.string "scheme_access", default: "none"
    t.bigint "department_ids", default: [], array: true
    t.bigint "scheme_ids", default: [], array: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "answers", force: :cascade do |t|
    t.bigint "questionnaire_id"
    t.bigint "user_id"
    t.bigint "scheme_id"
    t.string "user_answers", default: [], array: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["questionnaire_id"], name: "index_answers_on_questionnaire_id"
    t.index ["scheme_id"], name: "index_answers_on_scheme_id"
    t.index ["user_id"], name: "index_answers_on_user_id"
  end

  create_table "departments", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "enroll_in_mailings", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "enroll_ins", force: :cascade do |t|
    t.string "role"
    t.boolean "matched"
    t.bigint "user_id"
    t.bigint "scheme_id"
    t.integer "priority_score"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "mentees_number"
    t.index ["scheme_id"], name: "index_enroll_ins_on_scheme_id"
    t.index ["user_id"], name: "index_enroll_ins_on_user_id"
  end

  create_table "enroll_links", force: :cascade do |t|
    t.string "mentee_link"
    t.string "mentor_link"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "scheme_id"
    t.index ["scheme_id"], name: "index_enroll_links_on_scheme_id"
  end

  create_table "mailing_lists", force: :cascade do |t|
    t.string "email"
  end

  create_table "matches", force: :cascade do |t|
    t.bigint "mentor_id"
    t.bigint "mentee_id"
    t.bigint "scheme_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["mentee_id"], name: "index_matches_on_mentee_id"
    t.index ["mentor_id"], name: "index_matches_on_mentor_id"
    t.index ["scheme_id"], name: "index_matches_on_scheme_id"
  end

  create_table "questionnaires", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.bigint "scheme_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["scheme_id"], name: "index_questionnaires_on_scheme_id"
  end

  create_table "questions", force: :cascade do |t|
    t.bigint "questionnaire_id"
    t.string "description"
    t.string "options", default: [], array: true
    t.boolean "match"
    t.boolean "matching_up_to_user"
    t.boolean "give_priority"
    t.index ["questionnaire_id"], name: "index_questions_on_questionnaire_id"
  end

  create_table "reports", force: :cascade do |t|
    t.integer "reporter_id"
    t.integer "reportee_id"
    t.text "message"
    t.boolean "handled", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["reporter_id", "reportee_id"], name: "index_reports_on_reporter_id_and_reportee_id", unique: true
  end

  create_table "schemes", force: :cascade do |t|
    t.string "description", null: false
    t.string "codeOfConduct", null: false
    t.boolean "has_questionnaire"
    t.date "endDate", null: false
    t.date "startDate", null: false
    t.bigint "department_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "title", null: false
    t.index ["department_id"], name: "index_schemes_on_department_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
