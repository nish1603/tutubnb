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

ActiveRecord::Schema.define(:version => 20120830091805) do

  create_table "details", :force => true do |t|
    t.string   "accomodation"
    t.integer  "bedrooms"
    t.integer  "beds"
    t.string   "bed_type"
    t.integer  "bathrooms"
    t.float    "size"
    t.string   "unit"
    t.boolean  "pets"
    t.integer  "place_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "places", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "property_type"
    t.string   "room_type"
    t.integer  "user_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "prices", :force => true do |t|
    t.float    "daily"
    t.float    "weekend"
    t.float    "weekly"
    t.float    "monthly"
    t.integer  "max_guests"
    t.integer  "add_guests"
    t.float    "add_price"
    t.integer  "place_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "gender"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

end
