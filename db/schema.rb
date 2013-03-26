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

ActiveRecord::Schema.define(:version => 20130319140910) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.string   "iso_code"
    t.string   "iso3_code"
    t.float    "score"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "country_categories", :force => true do |t|
    t.integer  "country_id"
    t.integer  "category_id"
    t.float    "score"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "country_categories", ["category_id"], :name => "index_country_categories_on_category_id"
  add_index "country_categories", ["country_id"], :name => "index_country_categories_on_country_id"

  create_table "country_languages", :force => true do |t|
    t.integer  "country_id"
    t.integer  "language_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "country_languages", ["country_id"], :name => "index_country_languages_on_country_id"
  add_index "country_languages", ["language_id"], :name => "index_country_languages_on_language_id"

  create_table "data", :force => true do |t|
    t.integer  "datum_source_id"
    t.datetime "start_date"
    t.integer  "country_id"
    t.integer  "language_id"
    t.float    "original_value"
    t.text     "value"
    t.string   "type"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "data", ["country_id"], :name => "index_data_on_country_id"
  add_index "data", ["datum_source_id"], :name => "index_data_on_datum_source_id"
  add_index "data", ["language_id"], :name => "index_data_on_language_id"

  create_table "datum_sources", :force => true do |t|
    t.string   "admin_name"
    t.string   "public_name"
    t.text     "description"
    t.string   "datum_type"
    t.integer  "category_id"
    t.float    "default_weight"
    t.float    "min"
    t.float    "max"
    t.string   "retriever_class"
    t.boolean  "is_api"
    t.boolean  "for_infobox"
    t.string   "link"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "datum_sources", ["category_id"], :name => "index_datum_sources_on_category_id"

  create_table "languages", :force => true do |t|
    t.string   "name"
    t.string   "iso_code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
