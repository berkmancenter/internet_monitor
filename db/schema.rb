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

ActiveRecord::Schema.define(version: 20170823181764) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "slug",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "countries", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.string   "iso_code",           limit: 255
    t.string   "iso3_code",          limit: 255
    t.float    "score"
    t.text     "description"
    t.integer  "indicator_count"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.integer  "rank"
    t.integer  "access_group_count"
    t.string   "bbox",               limit: 255
    t.string   "slug",               limit: 255
    t.boolean  "region",                         default: false
  end

  create_table "country_categories", force: :cascade do |t|
    t.integer  "country_id"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "country_categories", ["category_id"], name: "index_country_categories_on_category_id", using: :btree
  add_index "country_categories", ["country_id"], name: "index_country_categories_on_country_id", using: :btree

  create_table "country_languages", force: :cascade do |t|
    t.integer  "country_id"
    t.integer  "language_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "country_languages", ["country_id"], name: "index_country_languages_on_country_id", using: :btree
  add_index "country_languages", ["language_id"], name: "index_country_languages_on_language_id", using: :btree

  create_table "data", force: :cascade do |t|
    t.integer  "datum_source_id"
    t.datetime "start_date"
    t.integer  "country_id"
    t.integer  "language_id"
    t.text     "original_value"
    t.text     "value"
    t.string   "type",            limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "value_id",        limit: 255
    t.string   "index_name",      limit: 255
  end

  add_index "data", ["country_id"], name: "index_data_on_country_id", using: :btree
  add_index "data", ["datum_source_id"], name: "index_data_on_datum_source_id", using: :btree
  add_index "data", ["language_id"], name: "index_data_on_language_id", using: :btree

  create_table "datum_sources", force: :cascade do |t|
    t.string   "admin_name",       limit: 255
    t.string   "public_name",      limit: 255
    t.text     "description"
    t.string   "datum_type",       limit: 255
    t.integer  "category_id"
    t.float    "default_weight"
    t.float    "min"
    t.float    "max"
    t.string   "retriever_class",  limit: 255
    t.boolean  "is_api"
    t.boolean  "in_sidebar"
    t.boolean  "affects_score"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.boolean  "requires_page"
    t.string   "source_name",      limit: 255
    t.string   "source_link",      limit: 255
    t.boolean  "in_category_page"
    t.string   "display_prefix",   limit: 255
    t.string   "display_suffix",   limit: 255
    t.integer  "precision"
    t.integer  "group_id"
    t.boolean  "normalized",                   default: false
    t.boolean  "display_original",             default: true
    t.string   "api_endpoint",     limit: 255
    t.float    "multiplier",                   default: 1.0
    t.string   "normalized_name",  limit: 255
    t.boolean  "invert",                       default: false
    t.string   "short_name",       limit: 255
    t.string   "display_class",    limit: 255
    t.integer  "provider_id"
  end

  add_index "datum_sources", ["category_id"], name: "index_datum_sources_on_category_id", using: :btree
  add_index "datum_sources", ["group_id"], name: "index_datum_sources_on_group_id", using: :btree

  create_table "groups", force: :cascade do |t|
    t.string   "admin_name",     limit: 255
    t.string   "public_name",    limit: 255
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.float    "default_weight",             default: 1.0
  end

  create_table "languages", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "iso_code",   limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "providers", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "short_name", limit: 255
    t.string   "url",        limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "refinery_authentication_devise_roles", force: :cascade do |t|
    t.string "title", limit: 255
  end

  create_table "refinery_authentication_devise_roles_users", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "refinery_authentication_devise_roles_users", ["role_id", "user_id"], name: "refinery_roles_users_role_id_user_id", using: :btree
  add_index "refinery_authentication_devise_roles_users", ["user_id", "role_id"], name: "refinery_roles_users_user_id_role_id", using: :btree

  create_table "refinery_authentication_devise_user_plugins", force: :cascade do |t|
    t.integer "user_id"
    t.string  "name",     limit: 255
    t.integer "position"
  end

  add_index "refinery_authentication_devise_user_plugins", ["name"], name: "index_refinery_authentication_devise_user_plugins_on_name", using: :btree
  add_index "refinery_authentication_devise_user_plugins", ["user_id", "name"], name: "refinery_user_plugins_user_id_name", unique: true, using: :btree

  create_table "refinery_authentication_devise_users", force: :cascade do |t|
    t.string   "username",               limit: 255, null: false
    t.string   "email",                  limit: 255, null: false
    t.string   "encrypted_password",     limit: 255, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.integer  "sign_in_count"
    t.datetime "remember_created_at"
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "slug",                   limit: 255
    t.string   "full_name"
  end

  add_index "refinery_authentication_devise_users", ["id"], name: "index_refinery_authentication_devise_users_on_id", using: :btree
  add_index "refinery_authentication_devise_users", ["slug"], name: "index_refinery_authentication_devise_users_on_slug", using: :btree

  create_table "refinery_blog_categories", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "slug",       limit: 255
  end

  add_index "refinery_blog_categories", ["id"], name: "index_refinery_blog_categories_on_id", using: :btree
  add_index "refinery_blog_categories", ["slug"], name: "index_refinery_blog_categories_on_slug", using: :btree

  create_table "refinery_blog_categories_blog_posts", force: :cascade do |t|
    t.integer "blog_category_id"
    t.integer "blog_post_id"
  end

  add_index "refinery_blog_categories_blog_posts", ["blog_category_id", "blog_post_id"], name: "index_blog_categories_blog_posts_on_bc_and_bp", using: :btree

  create_table "refinery_blog_category_translations", force: :cascade do |t|
    t.integer  "refinery_blog_category_id"
    t.string   "locale",                    limit: 255
    t.string   "title",                     limit: 255
    t.string   "slug",                      limit: 255
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "refinery_blog_category_translations", ["locale"], name: "index_refinery_blog_category_translations_on_locale", using: :btree
  add_index "refinery_blog_category_translations", ["refinery_blog_category_id"], name: "index_a0315945e6213bbe0610724da0ee2de681b77c31", using: :btree

  create_table "refinery_blog_comments", force: :cascade do |t|
    t.integer  "blog_post_id"
    t.boolean  "spam"
    t.string   "name",         limit: 255
    t.string   "email",        limit: 255
    t.text     "body"
    t.string   "state",        limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "refinery_blog_comments", ["id"], name: "index_refinery_blog_comments_on_id", using: :btree

  create_table "refinery_blog_post_translations", force: :cascade do |t|
    t.integer  "refinery_blog_post_id"
    t.string   "locale",                limit: 255
    t.text     "body"
    t.text     "custom_teaser"
    t.string   "custom_url",            limit: 255
    t.string   "slug",                  limit: 255
    t.string   "title",                 limit: 255
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "refinery_blog_post_translations", ["locale"], name: "index_refinery_blog_post_translations_on_locale", using: :btree
  add_index "refinery_blog_post_translations", ["refinery_blog_post_id"], name: "index_refinery_blog_post_translations_on_refinery_blog_post_id", using: :btree

  create_table "refinery_blog_posts", force: :cascade do |t|
    t.string   "title",            limit: 255
    t.text     "body"
    t.boolean  "draft"
    t.datetime "published_at"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "user_id"
    t.string   "custom_url",       limit: 255
    t.text     "custom_teaser"
    t.string   "source_url",       limit: 255
    t.string   "source_url_title", limit: 255
    t.integer  "access_count",                 default: 0
    t.string   "slug",             limit: 255
  end

  add_index "refinery_blog_posts", ["access_count"], name: "index_refinery_blog_posts_on_access_count", using: :btree
  add_index "refinery_blog_posts", ["id"], name: "index_refinery_blog_posts_on_id", using: :btree
  add_index "refinery_blog_posts", ["slug"], name: "index_refinery_blog_posts_on_slug", using: :btree

  create_table "refinery_image_translations", force: :cascade do |t|
    t.integer  "refinery_image_id", null: false
    t.string   "locale",            null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "image_alt"
    t.string   "image_title"
  end

  add_index "refinery_image_translations", ["locale"], name: "index_refinery_image_translations_on_locale", using: :btree
  add_index "refinery_image_translations", ["refinery_image_id"], name: "index_refinery_image_translations_on_refinery_image_id", using: :btree

  create_table "refinery_images", force: :cascade do |t|
    t.string   "image_mime_type", limit: 255
    t.string   "image_name",      limit: 255
    t.integer  "image_size"
    t.integer  "image_width"
    t.integer  "image_height"
    t.string   "image_uid",       limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "image_title"
    t.string   "image_alt"
  end

  create_table "refinery_page_part_translations", force: :cascade do |t|
    t.integer  "refinery_page_part_id"
    t.string   "locale",                limit: 255
    t.text     "body"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "refinery_page_part_translations", ["locale"], name: "index_refinery_page_part_translations_on_locale", using: :btree
  add_index "refinery_page_part_translations", ["refinery_page_part_id"], name: "index_refinery_page_part_translations_on_refinery_page_part_id", using: :btree

  create_table "refinery_page_parts", force: :cascade do |t|
    t.integer  "refinery_page_id"
    t.string   "slug",             limit: 255
    t.text     "body"
    t.integer  "position"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "title"
  end

  add_index "refinery_page_parts", ["id"], name: "index_refinery_page_parts_on_id", using: :btree
  add_index "refinery_page_parts", ["refinery_page_id"], name: "index_refinery_page_parts_on_refinery_page_id", using: :btree

  create_table "refinery_page_translations", force: :cascade do |t|
    t.integer  "refinery_page_id"
    t.string   "locale",           limit: 255
    t.string   "title",            limit: 255
    t.string   "custom_slug",      limit: 255
    t.string   "menu_title",       limit: 255
    t.string   "slug",             limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "refinery_page_translations", ["locale"], name: "index_refinery_page_translations_on_locale", using: :btree
  add_index "refinery_page_translations", ["refinery_page_id"], name: "index_refinery_page_translations_on_refinery_page_id", using: :btree

  create_table "refinery_pages", force: :cascade do |t|
    t.integer  "parent_id"
    t.string   "path",                limit: 255
    t.string   "slug",                limit: 255
    t.boolean  "show_in_menu",                    default: true
    t.string   "link_url",            limit: 255
    t.string   "menu_match",          limit: 255
    t.boolean  "deletable",                       default: true
    t.boolean  "draft",                           default: false
    t.boolean  "skip_to_first_child",             default: false
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.string   "view_template",       limit: 255
    t.string   "layout_template",     limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "custom_slug"
  end

  add_index "refinery_pages", ["depth"], name: "index_refinery_pages_on_depth", using: :btree
  add_index "refinery_pages", ["id"], name: "index_refinery_pages_on_id", using: :btree
  add_index "refinery_pages", ["lft"], name: "index_refinery_pages_on_lft", using: :btree
  add_index "refinery_pages", ["parent_id"], name: "index_refinery_pages_on_parent_id", using: :btree
  add_index "refinery_pages", ["rgt"], name: "index_refinery_pages_on_rgt", using: :btree

  create_table "refinery_resource_translations", force: :cascade do |t|
    t.integer  "refinery_resource_id", null: false
    t.string   "locale",               null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "resource_title"
  end

  add_index "refinery_resource_translations", ["locale"], name: "index_refinery_resource_translations_on_locale", using: :btree
  add_index "refinery_resource_translations", ["refinery_resource_id"], name: "index_refinery_resource_translations_on_refinery_resource_id", using: :btree

  create_table "refinery_resources", force: :cascade do |t|
    t.string   "file_mime_type", limit: 255
    t.string   "file_name",      limit: 255
    t.integer  "file_size"
    t.string   "file_uid",       limit: 255
    t.string   "file_ext",       limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "refinery_settings", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.text     "value"
    t.boolean  "destroyable",                 default: true
    t.string   "scoping",         limit: 255
    t.boolean  "restricted",                  default: false
    t.string   "form_value_type", limit: 255
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.string   "slug",            limit: 255
    t.string   "title"
  end

  add_index "refinery_settings", ["name"], name: "index_refinery_settings_on_name", using: :btree

  create_table "seo_meta", force: :cascade do |t|
    t.integer  "seo_meta_id"
    t.string   "seo_meta_type",    limit: 255
    t.string   "browser_title",    limit: 255
    t.text     "meta_description"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "seo_meta", ["id"], name: "index_seo_meta_on_id", using: :btree
  add_index "seo_meta", ["seo_meta_id", "seo_meta_type"], name: "index_seo_meta_on_seo_meta_id_and_seo_meta_type", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type", limit: 255
    t.integer  "tagger_id"
    t.string   "tagger_type",   limit: 255
    t.string   "context",       limit: 255
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name",           limit: 255
    t.integer "taggings_count",             default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

end
