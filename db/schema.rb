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

ActiveRecord::Schema.define(:version => 20120930003700) do

  create_table "agreements", :force => true do |t|
    t.string "name"
    t.integer "subcontractor_id"
    t.integer "provider_id"
    t.text "description"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "assignments", :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "customers", :force => true do |t|
    t.string "name"
    t.integer "organization_id"
    t.string "company"
    t.string "address1"
    t.string "address2"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "country"
    t.string "phone"
    t.string "mobile_phone"
    t.string "work_phone"
    t.string "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "events", :force => true do |t|
    t.string "name"
    t.string "type"
    t.string "description"
    t.string "eventable_type"
    t.integer "eventable_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer "user_id"
    t.integer "reference_id"
  end

  add_index "events", ["eventable_id", "eventable_type"], :name => "index_events_on_eventable_id_and_eventable_type"

  create_table "org_to_roles", :force => true do |t|
    t.integer "organization_id"
    t.integer "organization_role_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "org_to_roles", ["organization_id", "organization_role_id"], :name => "index_org_to_roles_on_organization_id_and_organization_role_id"

  create_table "organization_roles", :id => false, :force => true do |t|
    t.integer "id", :null => false
    t.string "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "organizations", :force => true do |t|
    t.string "name"
    t.string "phone"
    t.string "website"
    t.string "company"
    t.string "address1"
    t.string "address2"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "country"
    t.string "mobile"
    t.string "work_phone"
    t.string "email"
    t.boolean "subcontrax_member"
    t.integer "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "roles", :force => true do |t|
    t.string "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "service_calls", :force => true do |t|
    t.integer "customer_id"
    t.text "notes"
    t.datetime "started_on"
    t.integer "organization_id"
    t.datetime "completed_on"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer "status"
    t.integer "subcontractor_id"
    t.integer "technician_id"
    t.integer "provider_id"
    t.integer "subcontractor_status"
    t.string "type"
    t.integer "ref_id"
    t.integer "creator_id"
    t.integer "updater_id"
  end

  add_index "service_calls", ["ref_id"], :name => "index_service_calls_on_ref_id"

  create_table "users", :force => true do |t|
    t.string "email", :default => "", :null => false
    t.string "encrypted_password", :default => "", :null => false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer "organization_id"
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.string "company"
    t.string "address1"
    t.string "address2"
    t.string "country"
    t.string "state"
    t.string "city"
    t.string "zip"
    t.string "mobile_phone"
    t.string "work_phone"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
