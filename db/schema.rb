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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130821001454) do

  create_table "achievementnames", :force => true do |t|
    t.integer  "college_id"
    t.string   "achievementname"
    t.integer  "hourreq"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "achievementtypes", :force => true do |t|
    t.integer  "institution_id"
    t.string   "achievementtype"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "aps", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "awards", :force => true do |t|
    t.string   "awardtitle"
    t.integer  "year"
    t.string   "providername"
    t.text     "tipsforapp"
    t.text     "awardperks"
    t.text     "awardprereqs"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "user_id"
  end

  create_table "bounds", :force => true do |t|
    t.integer  "dep_id"
    t.integer  "min"
    t.integer  "max"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "catalogs", :force => true do |t|
    t.integer  "institution_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "ccourses", :force => true do |t|
    t.integer  "corereq_id"
    t.string   "department"
    t.integer  "num"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "cexceptions", :force => true do |t|
    t.integer  "dep_id"
    t.string   "department"
    t.integer  "num"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "clists", :force => true do |t|
    t.integer  "dep_id"
    t.string   "department"
    t.integer  "num"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "coleges", :force => true do |t|
    t.integer  "catalog_id"
    t.string   "colegename"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "colleges", :force => true do |t|
    t.integer  "achievementtype_id"
    t.string   "college"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "conferences", :force => true do |t|
    t.string   "conferencename"
    t.text     "tipsforapp"
    t.text     "contakeaway"
    t.datetime "conbegin"
    t.datetime "conend"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "user_id"
  end

  create_table "corereqs", :force => true do |t|
    t.integer  "specialty_id"
    t.string   "corereqname"
    t.integer  "cgoal"
    t.integer  "hgoal"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "courses", :force => true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "departments", :force => true do |t|
    t.integer  "colege_id"
    t.string   "departmentabbr"
    t.string   "departmentname"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "depnumreqs", :force => true do |t|
    t.integer  "specialty_id"
    t.string   "depnumreqname"
    t.integer  "cgoal"
    t.integer  "hgoal"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "doublecount"
  end

  create_table "deps", :force => true do |t|
    t.integer  "depnumreq_id"
    t.string   "department"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "groupopreqs", :force => true do |t|
    t.integer  "specialty_id"
    t.string   "groupopreqname"
    t.integer  "ggoal"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "groups", :force => true do |t|
    t.integer  "groupopreq_id"
    t.string   "groupname"
    t.integer  "cgoal"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "institutions", :force => true do |t|
    t.string   "name"
    t.string   "nickname"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "internships", :force => true do |t|
    t.string   "providername"
    t.string   "stutitle"
    t.text     "source"
    t.text     "internprereqs"
    t.text     "tipsforapp"
    t.datetime "internbegin"
    t.datetime "internend"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "user_id"
  end

  create_table "microposts", :force => true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "nums", :force => true do |t|
    t.integer  "department_id"
    t.string   "brief"
    t.integer  "credit"
    t.boolean  "di"
    t.boolean  "dii"
    t.boolean  "diii"
    t.integer  "number"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "name"
  end

  create_table "ocourses", :force => true do |t|
    t.string   "department"
    t.integer  "num"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "option_id"
  end

  create_table "offereds", :force => true do |t|
    t.integer  "num_id"
    t.string   "professor"
    t.string   "semester"
    t.integer  "year"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "opreqs", :force => true do |t|
    t.integer  "specialty_id"
    t.string   "opreqname"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "options", :force => true do |t|
    t.integer  "opreq_id"
    t.string   "optionname"
    t.integer  "cgoal"
    t.integer  "hgoal"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "group_id"
  end

  create_table "relationships", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "relationships", ["followed_id"], :name => "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], :name => "index_relationships_on_follower_id_and_followed_id", :unique => true
  add_index "relationships", ["follower_id"], :name => "index_relationships_on_follower_id"

  create_table "semesters", :force => true do |t|
    t.string   "semester"
    t.integer  "year_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "specialties", :force => true do |t|
    t.integer  "achievementname_id"
    t.string   "specialty"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.text     "notes"
    t.string   "linkhome"
    t.string   "advisor"
  end

  create_table "transfers", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "userachievementtypes", :force => true do |t|
    t.integer  "user_id"
    t.string   "achievementtype"
    t.string   "college"
    t.string   "achievementname"
    t.string   "specialty"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "usercourses", :force => true do |t|
    t.string   "department"
    t.integer  "semester_id"
    t.string   "num"
    t.integer  "credits"
    t.string   "status"
    t.string   "institution"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "grade"
    t.string   "prof"
    t.integer  "profquality"
    t.integer  "hpweek"
    t.string   "follows"
    t.integer  "nomidterms"
    t.integer  "noessays"
    t.integer  "nopprojects"
    t.integer  "nogprojects"
    t.text     "suggest"
    t.integer  "nofinals"
    t.integer  "transfer_id"
    t.integer  "ap_id"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           :default => false
    t.string   "college"
    t.string   "dreamJob"
    t.string   "year"
    t.string   "status"
    t.text     "notesToFresh"
    t.text     "notesToMym"
    t.integer  "matricuYear"
    t.string   "postGradPlans"
    t.boolean  "hideemail"
    t.boolean  "hideprofile"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

  create_table "years", :force => true do |t|
    t.integer  "year"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
