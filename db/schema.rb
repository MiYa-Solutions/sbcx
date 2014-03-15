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

ActiveRecord::Schema.define(:version => 20140216195150) do

  create_table "accounting_entries", :force => true do |t|
    t.integer  "status"
    t.integer  "event_id"
    t.integer  "amount_cents",      :default => 0,     :null => false
    t.string   "amount_currency",   :default => "USD", :null => false
    t.integer  "ticket_id"
    t.integer  "account_id"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.string   "type"
    t.string   "description"
    t.integer  "balance_cents",     :default => 0,     :null => false
    t.string   "balance_currency",  :default => "USD", :null => false
    t.integer  "agreement_id"
    t.string   "external_ref"
    t.integer  "collector_id"
    t.string   "collector_type"
    t.integer  "matching_entry_id"
  end

  create_table "accounts", :force => true do |t|
    t.integer  "organization_id",                     :null => false
    t.integer  "accountable_id",                      :null => false
    t.string   "accountable_type",                    :null => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.integer  "balance_cents",    :default => 0,     :null => false
    t.string   "balance_currency", :default => "USD", :null => false
    t.integer  "synch_status"
  end

  add_index "accounts", ["accountable_id", "accountable_type"], :name => "index_accounts_on_accountable_id_and_accountable_type"
  add_index "accounts", ["organization_id"], :name => "index_accounts_on_organization_id"

  create_table "active_admin_comments", :force => true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_active_admin_comments_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "agreements", :force => true do |t|
    t.string   "name"
    t.integer  "counterparty_id"
    t.integer  "organization_id"
    t.text     "description"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "status"
    t.string   "counterparty_type"
    t.string   "type"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.string   "payment_terms"
  end

  create_table "appointments", :force => true do |t|
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.string   "title"
    t.text     "description"
    t.boolean  "all_day"
    t.boolean  "recurring"
    t.integer  "appointable_id"
    t.string   "appointable_type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.integer  "organization_id"
  end

  create_table "assignments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "boms", :force => true do |t|
    t.integer  "ticket_id"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.decimal  "quantity"
    t.integer  "material_id"
    t.integer  "cost_cents",     :default => 0,     :null => false
    t.string   "cost_currency",  :default => "USD", :null => false
    t.integer  "price_cents",    :default => 0,     :null => false
    t.string   "price_currency", :default => "USD", :null => false
    t.integer  "buyer_id"
    t.string   "buyer_type"
    t.integer  "creator_id"
    t.integer  "updater_id"
  end

  add_index "boms", ["material_id"], :name => "index_boms_on_material_id"

  create_table "customers", :force => true do |t|
    t.string   "name"
    t.integer  "organization_id"
    t.string   "company"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.string   "phone"
    t.string   "mobile_phone"
    t.string   "work_phone"
    t.string   "email"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "creator_id"
    t.integer  "updater_id"
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.string   "type"
    t.text     "description"
    t.string   "eventable_type"
    t.integer  "eventable_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.integer  "user_id"
    t.integer  "reference_id"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.integer  "triggering_event_id"
    t.hstore   "properties"
  end

  add_index "events", ["eventable_id", "eventable_type"], :name => "index_events_on_eventable_id_and_eventable_type"
  add_index "events", ["properties"], :name => "events_properties"

  create_table "invites", :force => true do |t|
    t.string   "message"
    t.integer  "organization_id"
    t.integer  "affiliate_id"
    t.integer  "status"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "creator_id"
    t.integer  "updater_id"
  end

  create_table "materials", :force => true do |t|
    t.integer  "organization_id"
    t.integer  "supplier_id"
    t.string   "name"
    t.text     "description"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.integer  "status"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.integer  "cost_cents",      :default => 0,     :null => false
    t.string   "cost_currency",   :default => "USD", :null => false
    t.integer  "price_cents",     :default => 0,     :null => false
    t.string   "price_currency",  :default => "USD", :null => false
    t.datetime "deleted_at"
  end

  add_index "materials", ["name"], :name => "index_materials_on_name"
  add_index "materials", ["organization_id"], :name => "index_materials_on_organization_id"
  add_index "materials", ["supplier_id"], :name => "index_materials_on_supplier_id"

  create_table "notifications", :force => true do |t|
    t.string   "subject"
    t.text     "content"
    t.integer  "status"
    t.integer  "user_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "notifiable_id"
    t.string   "notifiable_type"
    t.string   "type"
    t.integer  "event_id"
  end

  create_table "org_to_roles", :force => true do |t|
    t.integer  "organization_id"
    t.integer  "organization_role_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "org_to_roles", ["organization_id", "organization_role_id"], :name => "index_org_to_roles_on_organization_id_and_organization_role_id"

  create_table "organization_roles", :id => false, :force => true do |t|
    t.integer  "id",         :null => false
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "website"
    t.string   "company"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.string   "mobile"
    t.string   "work_phone"
    t.string   "email"
    t.boolean  "subcontrax_member"
    t.integer  "status"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "parent_org_id"
    t.string   "industry"
    t.string   "other_industry"
  end

  create_table "payments", :force => true do |t|
    t.integer  "agreement_id"
    t.string   "type"
    t.float    "rate"
    t.string   "rate_type"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "posting_rules", :force => true do |t|
    t.integer  "agreement_id"
    t.string   "type"
    t.decimal  "rate"
    t.string   "rate_type"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.hstore   "properties"
    t.boolean  "time_bound",     :default => false
    t.boolean  "sunday",         :default => false
    t.boolean  "monday",         :default => false
    t.boolean  "tuesday",        :default => false
    t.boolean  "wednesday",      :default => false
    t.boolean  "thursday",       :default => false
    t.boolean  "friday",         :default => false
    t.boolean  "saturday",       :default => false
    t.time     "sunday_from"
    t.time     "monday_from"
    t.time     "tuesday_from"
    t.time     "wednesday_from"
    t.time     "thursday_from"
    t.time     "friday_from"
    t.time     "saturday_from"
    t.time     "sunday_to"
    t.time     "monday_to"
    t.time     "tuesday_to"
    t.time     "wednesday_to"
    t.time     "thursday_to"
    t.time     "friday_to"
    t.time     "saturday_to"
  end

  add_index "posting_rules", ["properties"], :name => "posting_rule_properties"

# Could not dump table "queue_classic_jobs" because of following StandardError
#   Unknown type 'json' for column 'args'

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string  "name"
    t.integer "organization_id"
  end

  create_table "tickets", :force => true do |t|
    t.integer  "customer_id"
    t.text     "notes"
    t.datetime "started_on"
    t.integer  "organization_id"
    t.datetime "completed_on"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.integer  "status"
    t.integer  "subcontractor_id"
    t.integer  "technician_id"
    t.integer  "provider_id"
    t.integer  "subcontractor_status"
    t.string   "type"
    t.integer  "ref_id"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "settled_on"
    t.integer  "billing_status"
    t.datetime "settlement_date"
    t.string   "name"
    t.datetime "scheduled_for"
    t.boolean  "transferable",          :default => true
    t.boolean  "allow_collection",      :default => true
    t.integer  "collector_id"
    t.string   "collector_type"
    t.integer  "provider_status"
    t.integer  "work_status"
    t.boolean  "re_transfer",           :default => true
    t.string   "payment_type"
    t.string   "subcon_payment"
    t.string   "provider_payment"
    t.string   "company"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.string   "phone"
    t.string   "mobile_phone"
    t.string   "work_phone"
    t.string   "email"
    t.integer  "subcon_agreement_id"
    t.integer  "provider_agreement_id"
    t.float    "tax",                   :default => 0.0
    t.integer  "subcon_fee_cents",      :default => 0,     :null => false
    t.string   "subcon_fee_currency",   :default => "USD", :null => false
    t.hstore   "properties"
    t.string   "external_ref"
  end

  add_index "tickets", ["properties"], :name => "tickets_properties"
  add_index "tickets", ["ref_id"], :name => "index_service_calls_on_ref_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "organization_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.string   "company"
    t.string   "address1"
    t.string   "address2"
    t.string   "country"
    t.string   "state"
    t.string   "city"
    t.string   "zip"
    t.string   "mobile_phone"
    t.string   "work_phone"
    t.hstore   "preferences"
    t.string   "time_zone"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["preferences"], :name => "users_preferences"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.integer  "assoc_id"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

end
