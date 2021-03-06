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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120117071024) do

  create_table "admins", :force => true do |t|
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "email",                               :null => false
    t.string   "vinsol_id"
  end

  add_index "admins", ["authentication_token"], :name => "index_admins_on_authentication_token", :unique => true

  create_table "categories", :force => true do |t|
    t.string   "name",                           :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "questions_count", :default => 0
  end

  create_table "options", :force => true do |t|
    t.integer  "question_id",                    :null => false
    t.string   "body",                           :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "answer",      :default => false
  end

  add_index "options", ["question_id"], :name => "index_options_on_question_id"

  create_table "questions", :force => true do |t|
    t.text     "body",                                  :null => false
    t.integer  "level",                                 :null => false
    t.integer  "category_id",                           :null => false
    t.integer  "admin_id",                              :null => false
    t.string   "type",        :default => "Subjective", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
  end

  add_index "questions", ["admin_id"], :name => "index_questions_on_admin_id"
  add_index "questions", ["category_id"], :name => "index_questions_on_category_id"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

end
