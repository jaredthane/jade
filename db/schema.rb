# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100124015441) do

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.integer  "entity_id"
    t.string   "number"
    t.integer  "modifier"
    t.integer  "balance",    :limit => 10, :precision => 10, :scale => 0
    t.boolean  "is_parent"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "base_contracts", :force => true do |t|
    t.integer  "site_id"
    t.integer  "total",              :limit => 10, :precision => 10, :scale => 0
    t.text     "comments"
    t.datetime "deleted_at"
    t.integer  "deleted_by"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "completed_at"
    t.datetime "completed_by"
    t.string   "type"
    t.integer  "paid",               :limit => 10, :precision => 10, :scale => 0
    t.integer  "next_id"
    t.string   "document_filename"
    t.datetime "document_generated"
    t.string   "document_number"
    t.integer  "entity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "base_lines", :force => true do |t|
    t.string   "product_id"
    t.integer  "parent_id"
    t.integer  "quantity"
    t.integer  "value1",           :limit => 10, :precision => 10, :scale => 0
    t.integer  "value2",           :limit => 10, :precision => 10, :scale => 0
    t.datetime "completed_at"
    t.integer  "completed_by"
    t.string   "serial_number_id"
    t.text     "comments"
    t.string   "type"
    t.integer  "old_qty"
  end

  create_table "base_products", :force => true do |t|
    t.string  "name"
    t.text    "description"
    t.integer "vendor_id"
    t.integer "unit_id"
    t.string  "location"
    t.string  "model"
    t.string  "manufacturer"
    t.boolean "uses_serial"
    t.string  "type"
    t.integer "category_id"
    t.integer "revenue_account_id"
  end

  create_table "categories", :force => true do |t|
    t.string  "name",               :default => ""
    t.integer "revenue_account_id"
  end

  create_table "entities", :force => true do |t|
    t.string   "name"
    t.string   "type"
    t.string   "home_phone"
    t.string   "office_phone"
    t.string   "fax_number"
    t.text     "address"
    t.boolean  "active"
    t.integer  "state_id"
    t.string   "cell_phone"
    t.string   "tax_id"
    t.string   "city"
    t.string   "email"
    t.string   "business"
    t.string   "register"
    t.integer  "cash_account_id"
    t.integer  "revenue_account_id"
    t.integer  "tax_account_id"
    t.text     "comments"
    t.datetime "birth"
    t.integer  "price_group_id"
    t.integer  "user_id"
    t.integer  "site_id"
    t.datetime "payday"
    t.integer  "price_set_id"
    t.string   "next_receipt_number"
    t.integer  "client_accounts_group_id"
    t.integer  "vendor_acccounts_group_id"
    t.integer  "inventory_account_id"
    t.integer  "expense_account_id"
    t.integer  "returns_account_id"
    t.integer  "discounts_account_id"
    t.integer  "payables_account_id"
    t.string   "next_bar_code"
  end

  create_table "entries", :force => true do |t|
    t.integer  "movement_id"
    t.integer  "value",       :limit => 10, :precision => 10, :scale => 0
    t.integer  "account_id"
    t.integer  "balance",     :limit => 10, :precision => 10, :scale => 0
    t.string   "product_id"
    t.integer  "quantity"
    t.string   "serial_id"
    t.integer  "entity_id"
    t.integer  "stock"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inventories", :force => true do |t|
    t.string  "product_id"
    t.integer "entity_id"
    t.integer "min"
    t.integer "max"
    t.integer "to_order"
    t.integer "quantity"
    t.integer "default_sales_warranty_id"
    t.integer "default_purchase_warrany_id"
    t.integer "cost",                        :limit => 10, :precision => 10, :scale => 0
    t.integer "default_cost",                :limit => 10, :precision => 10, :scale => 0
    t.integer "blocked_by"
  end

  create_table "logs", :force => true do |t|
    t.integer  "severity"
    t.string   "msg"
    t.string   "object_class", :limit => 32
    t.integer  "object_id"
    t.datetime "created_at"
  end

  create_table "movements", :force => true do |t|
    t.integer  "object_id"
    t.integer  "created_by"
    t.datetime "created_at"
    t.text     "comments"
    t.string   "type"
    t.integer  "direction"
    t.string   "category"
  end

  create_table "preferences", :force => true do |t|
    t.string "value"
  end

  create_table "price_groups", :force => true do |t|
    t.string "name"
  end

  create_table "price_sets", :force => true do |t|
    t.integer "price_group_id"
    t.integer "entity_id"
  end

  create_table "prices", :force => true do |t|
    t.integer "price_set_id"
    t.string  "product_id"
    t.decimal "fixed",        :precision => 8, :scale => 2
    t.decimal "relative",     :precision => 8, :scale => 2
    t.boolean "available"
  end

  create_table "right_roles", :force => true do |t|
    t.integer "role_id"
    t.integer "right_id"
  end

  create_table "rights", :force => true do |t|
    t.string "name"
  end

  create_table "role_users", :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  create_table "roles", :force => true do |t|
    t.string "name"
  end

  create_table "serials", :force => true do |t|
  end

  create_table "states", :force => true do |t|
    t.string "name"
  end

  create_table "subscriptions", :force => true do |t|
    t.string   "name"
    t.integer  "client_id"
    t.integer  "vendor_id"
    t.integer  "quantity",                                     :default => 1
    t.datetime "end_date"
    t.integer  "end_times"
    t.decimal  "fixed_price",    :precision => 8, :scale => 2, :default => 0.0
    t.decimal  "relative_price", :precision => 8, :scale => 2, :default => 0.0
    t.string   "product_id"
    t.integer  "frequency",                                    :default => 1
    t.datetime "created_at"
    t.datetime "next_date"
  end

  create_table "units", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.integer  "site_id"
    t.boolean  "default_received"
    t.integer  "price_group_id"
    t.integer  "cash_account_id"
    t.integer  "personal_account_id"
    t.integer  "revenue_account_id"
    t.boolean  "do_accounting",                           :default => true
    t.string   "name"
    t.string   "default_page"
    t.date     "date"
  end

  create_table "warranties", :force => true do |t|
    t.string  "product_id"
    t.decimal "price",      :precision => 8, :scale => 2
    t.integer "order_type"
    t.integer "months"
  end

end
