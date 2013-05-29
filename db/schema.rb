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

ActiveRecord::Schema.define(:version => 20130429193835) do

  create_table "comments", :force => true do |t|
    t.string   "content"
    t.integer  "num_likes",  :default => 0
    t.integer  "user_id"
    t.integer  "idea_id"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "committees_tags", :id => false, :force => true do |t|
    t.integer "committee_id"
    t.integer "tag_id"
  end

  create_table "competition_entries", :force => true do |t|
    t.integer  "idea_id"
    t.integer  "competition_id"
    t.boolean  "approved",       :default => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.boolean  "rejected",       :default => false
  end

  add_index "competition_entries", ["competition_id"], :name => "index_competition_entries_on_competition_id"
  add_index "competition_entries", ["idea_id"], :name => "index_competition_entries_on_idea_id"

  create_table "competition_idea_notifications", :primary_key => "notification_id", :force => true do |t|
    t.string  "type"
    t.integer "idea_id"
    t.integer "user_id"
    t.integer "competition_id"
  end

  add_index "competition_idea_notifications", ["competition_id"], :name => "index_competition_idea_notifications_on_competition_id"
  add_index "competition_idea_notifications", ["idea_id"], :name => "index_competition_idea_notifications_on_idea_id"
  add_index "competition_idea_notifications", ["user_id"], :name => "index_competition_idea_notifications_on_user_id"

  create_table "competition_notifications", :primary_key => "notification_id", :force => true do |t|
    t.string  "type"
    t.integer "user_id"
    t.integer "competition_id"
  end

  add_index "competition_notifications", ["competition_id"], :name => "index_competition_notifications_on_competition_id"
  add_index "competition_notifications", ["user_id"], :name => "index_competition_notifications_on_user_id"

  create_table "competitions", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.integer  "investor_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "winner"
    t.integer  "idea_id"
    t.date     "start_date"
    t.date     "end_date"
  end

  add_index "competitions", ["investor_id"], :name => "index_competitions_on_investor_id"

  create_table "competitions_tags", :id => false, :force => true do |t|
    t.integer "competition_id"
    t.integer "tag_id"
  end

  create_table "delete_competition_notifications", :primary_key => "notification_id", :force => true do |t|
    t.string  "competition_title"
    t.integer "competition_id"
    t.integer "user_id"
  end

  add_index "delete_competition_notifications", ["competition_id"], :name => "index_delete_competition_notifications_on_competition_id"
  add_index "delete_competition_notifications", ["user_id"], :name => "index_delete_competition_notifications_on_user_id"

  create_table "delete_notifications", :primary_key => "notification_id", :force => true do |t|
    t.string  "idea_title"
    t.integer "idea_id"
    t.integer "user_id"
  end

  add_index "delete_notifications", ["idea_id"], :name => "index_delete_notifications_on_idea_id"
  add_index "delete_notifications", ["user_id"], :name => "index_delete_notifications_on_user_id"

  create_table "idea_notifications", :primary_key => "notification_id", :force => true do |t|
    t.string  "type"
    t.integer "idea_id"
    t.integer "user_id"
  end

  add_index "idea_notifications", ["idea_id"], :name => "index_idea_notifications_on_idea_id"
  add_index "idea_notifications", ["user_id"], :name => "index_idea_notifications_on_user_id"

  create_table "idea_notifications_users", :force => true do |t|
    t.integer "user_id"
    t.integer "idea_notification_id"
    t.boolean "read",                 :default => false
  end

  create_table "ideas", :force => true do |t|
    t.string   "title",              :limit => 100,                    :null => false
    t.string   "description",                                          :null => false
    t.string   "problem_solved",                                       :null => false
    t.integer  "num_votes",                         :default => 0
    t.integer  "user_id"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.boolean  "approved",                          :default => false
    t.integer  "committee_id"
    t.boolean  "archive_status",                    :default => false
    t.boolean  "rejected",                          :default => false
  end

  create_table "ideas_tags", :id => false, :force => true do |t|
    t.integer "idea_id"
    t.integer "tag_id"
  end

  create_table "inviteds", :force => true do |t|
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "admin_id"
  end

  create_table "likes", :id => false, :force => true do |t|
    t.integer "comment_id"
    t.integer "user_id"
  end

  create_table "monthly_winners", :force => true do |t|
    t.integer  "idea_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "notifications", :force => true do |t|
    t.string   "subtype",    :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "notifications_users", :force => true do |t|
    t.integer "user_id"
    t.integer "notification_id"
    t.boolean "read",            :default => false
  end

  create_table "ratings", :force => true do |t|
    t.string   "name"
    t.integer  "value"
    t.integer  "idea_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "similarities", :force => true do |t|
    t.integer  "idea_id"
    t.float    "similarity"
    t.integer  "similar_idea_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "similarities", ["idea_id"], :name => "index_similarities_on_idea_id"
  add_index "similarities", ["similar_idea_id"], :name => "index_similarities_on_similar_idea_id"

  create_table "tag_connections", :id => false, :force => true do |t|
    t.integer "tag_a_id", :null => false
    t.integer "tag_b_id", :null => false
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "thresholds", :force => true do |t|
    t.integer  "threshold"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "trends", :force => true do |t|
    t.integer "idea_id"
    t.integer "trending", :default => 0
    t.integer "rounds",   :default => 0
  end

  create_table "user_notifications", :primary_key => "notification_id", :force => true do |t|
    t.string  "type"
    t.integer "user_id"
  end

  add_index "user_notifications", ["user_id"], :name => "index_user_notifications_on_user_id"

  create_table "user_notifications_users", :force => true do |t|
    t.integer "user_id"
    t.integer "user_notification_id"
    t.boolean "read",                 :default => false
  end

  create_table "user_ratings", :force => true do |t|
    t.string   "name"
    t.integer  "value"
    t.integer  "user_id"
    t.integer  "rating_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                           :limit => 100,                    :null => false
    t.string   "password"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username"
    t.date     "date_of_birth"
    t.string   "gender",                          :limit => 1
    t.text     "about_me"
    t.datetime "created_at",                                                        :null => false
    t.datetime "updated_at",                                                        :null => false
    t.string   "encrypted_password",                             :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                  :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "authentication_token"
    t.string   "type"
    t.boolean  "active",                                         :default => true
    t.boolean  "banned",                                         :default => false
    t.boolean  "own_idea_notifications",                         :default => true
    t.boolean  "participated_idea_notifications",                :default => true
    t.string   "provider"
    t.string   "uid"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.boolean  "approved",                                       :default => false
    t.string   "secret"
    t.boolean  "facebook_share",                                 :default => true
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "vote_counts", :force => true do |t|
    t.integer "idea_id"
    t.integer "prev_day_votes", :default => 0
    t.integer "curr_day_votes", :default => 0
  end

  create_table "votes", :id => false, :force => true do |t|
    t.integer  "idea_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["idea_id", "user_id"], :name => "index_votes_on_idea_id_and_user_id", :unique => true

end
