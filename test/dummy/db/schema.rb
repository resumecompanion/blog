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

ActiveRecord::Schema.define(:version => 20130725063997) do

  create_table "blog_files", :force => true do |t|
    t.integer  "blog_user_id"
    t.string   "image"
    t.string   "title"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "blog_files", ["blog_user_id"], :name => "index_blog_files_on_blog_user_id"

  create_table "blog_navigations", :force => true do |t|
    t.string   "name"
    t.string   "link"
    t.string   "link_title"
    t.integer  "position",   :default => 0
    t.boolean  "is_hidden",  :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "blog_navigations", ["is_hidden"], :name => "index_blog_navigations_on_is_hidden"
  add_index "blog_navigations", ["position"], :name => "index_blog_navigations_on_position"

  create_table "blog_post_tag_relations", :force => true do |t|
    t.integer  "post_id"
    t.integer  "tag_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "blog_post_tag_relations", ["post_id"], :name => "index_blog_post_tag_relations_on_post_id"
  add_index "blog_post_tag_relations", ["tag_id"], :name => "index_blog_post_tag_relations_on_tag_id"

  create_table "blog_posts", :force => true do |t|
    t.integer  "author_id"
    t.integer  "sidebar_id"
    t.string   "title"
    t.string   "slug"
    t.string   "meta_description"
    t.string   "meta_keywords"
    t.text     "content"
    t.text     "excerpt"
    t.boolean  "is_published",     :default => true
    t.datetime "published_at"
    t.integer  "old_id"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "meta_title"
  end

  add_index "blog_posts", ["author_id"], :name => "index_blog_posts_on_author_id"
  add_index "blog_posts", ["is_published"], :name => "index_blog_posts_on_is_published"
  add_index "blog_posts", ["sidebar_id"], :name => "index_blog_posts_on_sidebar_id"
  add_index "blog_posts", ["slug"], :name => "index_blog_posts_on_slug"

  create_table "blog_settings", :force => true do |t|
    t.string   "key"
    t.string   "value"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "blog_settings", ["key"], :name => "index_blog_settings_on_key", :unique => true

  create_table "blog_sidebars", :force => true do |t|
    t.string   "name"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "blog_tags", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.boolean  "is_enabled",       :default => true
    t.string   "meta_description"
    t.string   "meta_keywords"
    t.integer  "old_id"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "blog_tags", ["is_enabled"], :name => "index_blog_tags_on_is_enabled"
  add_index "blog_tags", ["slug"], :name => "index_blog_tags_on_slug"

  create_table "blog_users", :force => true do |t|
    t.string   "nickname"
    t.boolean  "is_admin",               :default => false
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  add_index "blog_users", ["email"], :name => "index_blog_users_on_email", :unique => true
  add_index "blog_users", ["reset_password_token"], :name => "index_blog_users_on_reset_password_token", :unique => true

end
