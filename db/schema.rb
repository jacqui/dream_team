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

ActiveRecord::Schema.define(:version => 20121229203029) do

  create_table "conferences", :force => true do |t|
    t.string   "name"
    t.string   "abbreviation"
    t.string   "slug"
    t.integer  "league_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "divisions", :force => true do |t|
    t.string   "name"
    t.string   "abbreviation"
    t.string   "slug"
    t.integer  "conference_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "espn_group"
  end

  create_table "leagues", :force => true do |t|
    t.string   "name"
    t.string   "abbreviation"
    t.string   "slug"
    t.integer  "sport_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "pick_buckets", :force => true do |t|
    t.string   "pick_type",                        :null => false
    t.integer  "pick_window_id",                   :null => false
    t.integer  "count",                            :null => false
    t.boolean  "required",       :default => true, :null => false
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  create_table "pick_windows", :force => true do |t|
    t.datetime "window_start"
    t.datetime "window_end"
    t.integer  "project_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "picks", :force => true do |t|
    t.integer  "reader_id"
    t.integer  "pick_id"
    t.string   "pick_type"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "project_id"
    t.integer  "pick_window_id"
    t.integer  "pick_bucket_id"
  end

  create_table "players", :force => true do |t|
    t.string   "position"
    t.text     "bio"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "team_id"
    t.string   "full_name"
    t.integer  "source_id"
    t.string   "source"
    t.string   "slug"
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "readers", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "nytimes_id"
    t.string   "name"
    t.string   "username"
  end

  add_index "readers", ["nytimes_id"], :name => "index_readers_on_nytimes_id"

  create_table "sports", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "location"
    t.string   "color"
    t.string   "abbreviation"
    t.string   "source"
    t.integer  "source_id"
    t.integer  "sport_id"
    t.integer  "conference_id"
    t.integer  "division_id"
    t.integer  "league_id"
  end

  add_index "teams", ["abbreviation"], :name => "index_teams_on_abbreviation"
  add_index "teams", ["location"], :name => "index_teams_on_location"
  add_index "teams", ["name"], :name => "index_teams_on_name"

  create_table "unit_actions", :force => true do |t|
    t.integer  "points"
    t.string   "qualifying_metric_type"
    t.integer  "qualifying_metric_amount"
    t.string   "qualifying_position"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

end
