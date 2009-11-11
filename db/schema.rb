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

ActiveRecord::Schema.define(:version => 20081209161439) do

  create_table "accounts", :force => true do |t|
    t.string  "name"
    t.integer "parent_id"
    t.integer "entity_id"
    t.boolean "postable"
    t.string  "number",              :limit => 20
    t.boolean "transparent_journal"
    t.integer "modifier"
  end

  create_table "combo_line_types", :force => true do |t|
    t.string "name"
  end

  create_table "combo_lines", :force => true do |t|
    t.integer  "product_id"
    t.integer  "combo_id"
    t.integer  "quantity"
    t.integer  "serialized_product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "combo_line_type_id"
  end

  create_table "default_branches", :id => false, :force => true do |t|
    t.integer "entity_id"
    t.integer "entity_type_id"
    t.integer "account_id"
    t.string  "prefix",         :limit => 32, :default => ""
    t.string  "suffix",         :limit => 32, :default => ""
  end

  create_table "entities", :force => true do |t|
    t.string   "name"
    t.integer  "entity_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "home_phone",               :limit => 8,  :default => ""
    t.string   "office_phone",             :limit => 8,  :default => ""
    t.text     "address"
    t.datetime "birth"
    t.integer  "state_id"
    t.string   "cell_phone",               :limit => 8
    t.string   "nit",                      :limit => 14
    t.string   "city"
    t.string   "email"
    t.string   "register"
    t.string   "giro"
    t.integer  "price_group_id"
    t.integer  "price_group_name_id"
    t.integer  "user_id"
    t.integer  "product_id"
    t.integer  "site_id"
    t.integer  "inventory_account_id"
    t.integer  "cash_account_id"
    t.integer  "revenue_account_id"
    t.integer  "expense_account_id"
    t.integer  "returns_account_id"
    t.integer  "tax_account_id"
    t.integer  "payables_account_id"
    t.text     "notes"
    t.string   "oldid"
    t.integer  "subscription_day"
    t.boolean  "active",                                 :default => true
    t.integer  "next_receipt_number"
    t.integer  "client_accounts_group_id"
    t.integer  "vendor_accounts_group_id"
  end

  create_table "entity_types", :force => true do |t|
    t.string "name"
  end

  create_table "entries", :force => true do |t|
    t.integer  "post_id"
    t.integer  "account_id"
    t.decimal  "balance",    :precision => 8, :scale => 2
    t.datetime "created_at"
  end

  create_table "inventories", :force => true do |t|
    t.integer "product_id"
    t.integer "entity_id"
    t.integer "min"
    t.integer "max"
    t.integer "to_order"
    t.date    "created_at"
    t.date    "updated_at"
    t.integer "quantity"
    t.integer "default_warranty_sales_id"
    t.integer "default_warranty_purchases_id"
    t.decimal "cost",                          :precision => 8, :scale => 2
    t.decimal "default_cost",                  :precision => 8, :scale => 2
  end

  create_table "items", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "vendor_id"
    t.decimal  "oldcost",               :precision => 8, :scale => 2
    t.string   "upc"
    t.integer  "unit_id"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "model"
    t.boolean  "serialized"
    t.integer  "serialized_product_id"
    t.integer  "product_type_id"
    t.integer  "product_category_id"
    t.integer  "blocked_by_count",                                    :default => 0
    t.integer  "revenue_account_id"
  end

  create_table "lines", :force => true do |t|
    t.integer  "product_id"
    t.integer  "order_id"
    t.integer  "quantity",                                            :default => 0
    t.decimal  "price",                 :precision => 8, :scale => 2, :default => 0.0
    t.datetime "received"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "serialized_product_id"
    t.integer  "line_id"
    t.decimal  "warranty_price",        :precision => 8, :scale => 2, :default => 0.0
    t.integer  "warranty_id"
    t.decimal  "tax",                   :precision => 8, :scale => 2, :default => 0.0
    t.integer  "previous_qty"
    t.integer  "warranty_months"
    t.integer  "receipt_id"
    t.text     "note"
    t.decimal  "sales_tax",             :precision => 8, :scale => 2, :default => 0.0
  end

  create_table "movement_types", :force => true do |t|
    t.string "name"
  end

  create_table "movements", :force => true do |t|
    t.integer  "entity_id"
    t.integer  "product_id"
    t.integer  "quantity"
    t.integer  "movement_type_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "order_id"
    t.integer  "serialized_product_id"
    t.integer  "oldline_id"
    t.text     "comments"
    t.decimal  "value",                 :precision => 8, :scale => 2
    t.decimal  "balance",               :precision => 5, :scale => 2
    t.integer  "line_id"
  end

  create_table "order_types", :force => true do |t|
    t.string "name"
  end

  create_table "orders", :force => true do |t|
    t.integer  "vendor_id"
    t.integer  "client_id"
    t.date     "received"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "serialized_product_id"
    t.boolean  "last_batch"
    t.datetime "receipt_printed"
    t.text     "comments"
    t.integer  "order_type_id"
    t.boolean  "deleted",                                               :default => false
    t.decimal  "grand_total",             :precision => 8, :scale => 2, :default => 0.0
    t.decimal  "amount_paid",             :precision => 8, :scale => 2, :default => 0.0
    t.boolean  "d",                                                     :default => false
    t.integer  "purchase_receipt_number"
  end

  create_table "payment_methods", :force => true do |t|
    t.string "name"
  end

  create_table "payments", :force => true do |t|
    t.integer  "order_id"
    t.decimal  "amount",            :precision => 8, :scale => 2, :default => 0.0
    t.integer  "payment_method_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.decimal  "returned",          :precision => 8, :scale => 2, :default => 0.0
    t.integer  "receipt_id"
    t.decimal  "presented",         :precision => 8, :scale => 2, :default => 0.0
    t.boolean  "canceled",                                        :default => false
  end

  create_table "people", :force => true do |t|
    t.string   "home_phone",   :limit => 8,  :default => ""
    t.string   "office_phone", :limit => 8,  :default => ""
    t.text     "address"
    t.datetime "birth"
    t.integer  "state_id"
    t.string   "cell_phone",   :limit => 8
    t.string   "nit",          :limit => 14
    t.string   "city"
    t.string   "email"
    t.string   "register"
    t.string   "giro"
  end

  create_table "physical_count_lines", :force => true do |t|
    t.integer "product_id"
    t.integer "count"
    t.integer "physical_count_id"
  end

  create_table "physical_counts", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "entity_id"
    t.integer  "user_id"
  end

  create_table "post_types", :force => true do |t|
    t.string "name"
  end

  create_table "posts", :force => true do |t|
    t.integer  "post_type_id"
    t.decimal  "value",          :precision => 8, :scale => 2
    t.integer  "account_id"
    t.integer  "trans_id"
    t.decimal  "balance",        :precision => 8, :scale => 2
    t.integer  "transaction_id"
    t.datetime "created_at"
  end

  create_table "preferences", :force => true do |t|
    t.string  "name"
    t.integer "value"
    t.string  "pref_group"
  end

  create_table "price_group_names", :force => true do |t|
    t.string "name"
  end

  create_table "price_groups", :force => true do |t|
    t.integer "price_group_name_id"
    t.integer "entity_id"
  end

  create_table "prices", :force => true do |t|
    t.integer "price_group_id"
    t.integer "product_id"
    t.decimal "fixed",          :precision => 8, :scale => 2
    t.decimal "relative",       :precision => 8, :scale => 2
    t.boolean "available"
  end

  create_table "privileges", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_categories", :force => true do |t|
    t.string  "name",               :default => ""
    t.integer "revenue_account_id"
  end

  create_table "product_types", :force => true do |t|
    t.string "name"
  end

  create_table "products", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "vendor_id"
    t.decimal  "oldcost",               :precision => 8, :scale => 2
    t.string   "upc"
    t.integer  "unit_id"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "model"
    t.boolean  "serialized"
    t.integer  "serialized_product_id"
    t.integer  "product_type_id"
    t.integer  "product_category_id"
    t.integer  "blocked_by_count",                                    :default => 0
    t.integer  "revenue_account_id"
  end

  create_table "r", :force => true do |t|
    t.string   "oldid"
    t.integer  "num"
    t.string   "act1"
    t.string   "act2"
    t.decimal  "amt",       :precision => 8, :scale => 2
    t.datetime "fecha"
    t.integer  "client_id"
    t.integer  "order_id"
  end

  create_table "receipts", :force => true do |t|
    t.integer  "order_id"
    t.string   "filename"
    t.datetime "created_at"
    t.integer  "number"
    t.integer  "user_id"
    t.datetime "deleted"
    t.integer  "site_id"
  end

  create_table "requirements", :force => true do |t|
    t.integer "product_id"
    t.integer "required_id"
    t.integer "quantity"
    t.decimal "static_price",   :precision => 8, :scale => 2
    t.decimal "relative_price", :precision => 8, :scale => 2
  end

  create_table "rights", :force => true do |t|
    t.string "name"
  end

  create_table "rights_roles", :force => true do |t|
    t.integer "role_id"
    t.integer "right_id"
  end

  create_table "roles", :force => true do |t|
    t.string "title"
  end

  create_table "roles_users", :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  create_table "sales", :force => true do |t|
    t.string   "oldid"
    t.integer  "num"
    t.datetime "fecha"
    t.string   "act1"
    t.decimal  "amt",       :precision => 8, :scale => 2
    t.string   "act2"
    t.integer  "client_id"
    t.string   "nts"
  end

  create_table "schema_info", :id => false, :force => true do |t|
    t.integer "version"
  end

  create_table "serial_numbers", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id"
  end

  create_table "serialized_products", :force => true do |t|
    t.string  "serial_number"
    t.integer "product_id"
  end

  create_table "states", :force => true do |t|
    t.string "name"
  end

  create_table "subscriptions", :force => true do |t|
    t.string   "name"
    t.integer  "client_id"
    t.integer  "vendor_id"
    t.integer  "quantity",                                      :default => 1
    t.datetime "end_date"
    t.integer  "end_times"
    t.decimal  "fixed_price",     :precision => 8, :scale => 2, :default => 0.0
    t.decimal  "relative_price",  :precision => 8, :scale => 2, :default => 0.0
    t.integer  "last_line_id"
    t.integer  "product_id"
    t.integer  "frequency",                                     :default => 1
    t.datetime "created_at"
    t.datetime "next_order_date"
  end

  create_table "test", :force => true do |t|
    t.string "name"
  end

  create_table "test2", :id => false, :force => true do |t|
    t.boolean "tester"
  end

  create_table "trans", :force => true do |t|
    t.integer  "order_id"
    t.text     "comments"
    t.datetime "created_at"
    t.integer  "user_id"
  end

  create_table "transactions", :force => true do |t|
    t.integer "order_id"
    t.text    "comments"
  end

  create_table "units", :force => true do |t|
    t.string "name"
  end

  create_table "user_privileges", :force => true do |t|
    t.integer  "user_id"
    t.integer  "privilege_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.integer  "location_id"
    t.boolean  "default_received"
    t.integer  "price_group_name_id"
    t.integer  "cash_account_id"
    t.integer  "personal_account_id"
    t.integer  "revenue_account_id"
    t.boolean  "do_accounting",                           :default => true
    t.string   "name"
    t.string   "default_page"
    t.date     "date"
  end

  create_table "warranties", :force => true do |t|
    t.integer "product_id"
    t.decimal "price",         :precision => 8, :scale => 2
    t.integer "month_id"
    t.integer "order_type_id"
    t.integer "months"
  end

  create_table "warranty_months", :force => true do |t|
    t.integer "months"
  end

end
