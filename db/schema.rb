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

ActiveRecord::Schema.define(version: 20150605130938) do

  create_table "api_keys", force: true do |t|
    t.string   "token"
    t.boolean  "active",     default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "client_bugs", force: true do |t|
    t.text     "exception"
    t.text     "bug_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "club_configs", force: true do |t|
    t.string   "name"
    t.decimal  "entry_fees",    precision: 10, scale: 0
    t.decimal  "winner_amount", precision: 10, scale: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "club_type"
    t.integer  "rule_id"
    t.boolean  "active"
    t.integer  "winner_xp"
    t.integer  "looser_xp"
  end

  create_table "clubs", force: true do |t|
    t.string   "name"
    t.decimal  "entry_fees",     precision: 10, scale: 0
    t.decimal  "winner_amount",  precision: 10, scale: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "club_config_id"
  end

  create_table "dynamic_iaps", force: true do |t|
    t.string   "iap_id"
    t.decimal  "old_coins_value", precision: 10, scale: 0
    t.decimal  "new_coins_value", precision: 10, scale: 0
    t.decimal  "old_pricing",     precision: 10, scale: 0
    t.decimal  "new_pricing",     precision: 10, scale: 0
    t.boolean  "offer"
    t.string   "currency"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friend_requests", force: true do |t|
    t.integer  "requested_to_id"
    t.boolean  "confirmed",       default: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "friend_requests", ["user_id"], name: "index_friend_requests_on_user_id", using: :btree

  create_table "friendships", force: true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "game_requests", force: true do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.string   "requested_from"
    t.string   "requested_to"
    t.string   "invitation_type"
    t.boolean  "accepted",        default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", force: true do |t|
    t.integer  "club_config_id"
    t.integer  "winner_id"
    t.integer  "looser_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gift_requests", force: true do |t|
    t.integer  "user_id"
    t.integer  "send_to_id"
    t.boolean  "confirmed",                           default: false
    t.boolean  "is_asked",                            default: false
    t.string   "gift_type",                                           null: false
    t.decimal  "gift_value", precision: 10, scale: 0, default: 5
    t.decimal  "decimal",    precision: 10, scale: 0, default: 5
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "login_histories", force: true do |t|
    t.boolean  "active"
    t.integer  "user_id"
    t.string   "login_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                                                       default: "",    null: false
    t.string   "encrypted_password",                                          default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                               default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "fb_id"
    t.string   "device_id"
    t.string   "login_token"
    t.boolean  "is_guest",                                                    default: false
    t.boolean  "online",                                                      default: false
    t.integer  "won_count",                                                   default: 0
    t.integer  "lost_count",                                                  default: 0
    t.integer  "rank",                                                        default: 0
    t.decimal  "total_coins_won",                    precision: 10, scale: 0, default: 0
    t.decimal  "win_percentage",                     precision: 10, scale: 0, default: 0
    t.integer  "total_tournament_won",                                        default: 0
    t.integer  "total_tournament_played",                                     default: 0
    t.integer  "win_streak",                                                  default: 0
    t.decimal  "ball_potted",                        precision: 10, scale: 0, default: 0
    t.decimal  "accuracy",                           precision: 10, scale: 0, default: 0
    t.integer  "xp",                                                          default: 0
    t.integer  "current_level",                                               default: 1
    t.string   "country"
    t.string   "achievement"
    t.decimal  "current_coins_balance",              precision: 10, scale: 0, default: 1000
    t.boolean  "is_dummy",                                                    default: false
    t.decimal  "total_time_in_game",                 precision: 10, scale: 0, default: 0
    t.integer  "total_games_played",                                          default: 0
    t.binary   "flag"
    t.float    "strike_count",            limit: 24,                          default: 0.0
    t.integer  "device_avatar_id",                                            default: 0
    t.boolean  "is_fb_connected",                                             default: false
    t.string   "user_pool_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
