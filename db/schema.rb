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

ActiveRecord::Schema.define(version: 2021_02_02_062640) do

  create_table "campaigns", id: false, force: :cascade do |t|
    t.integer "campaign_id"
    t.string "name"
    t.string "cpi"
    t.integer "length_of_interview"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_campaigns_on_campaign_id", unique: true
  end

  create_table "qualifications", force: :cascade do |t|
    t.integer "quotum_id"
    t.integer "question_id"
    t.text "pre_codes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quotum_id", "question_id"], name: "index_qualifications_on_quotum_id_and_question_id", unique: true
    t.index ["quotum_id"], name: "index_qualifications_on_quotum_id"
  end

  create_table "quota", id: false, force: :cascade do |t|
    t.integer "campaign_id"
    t.integer "quotum_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id", "quotum_id"], name: "index_quota_on_campaign_id_and_quotum_id", unique: true
    t.index ["campaign_id"], name: "index_quota_on_campaign_id"
  end

end
