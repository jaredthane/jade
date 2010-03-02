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

ActiveRecord::Schema.define(:version => 20100220224933) do

  create_table "accounts", :force => true do |t|
    t.string  "name"
    t.integer "parent_id"
    t.integer "entity_id"
    t.string  "number",    :limit => 20
    t.integer "modifier"
    t.decimal "balance",                 :precision => 8, :scale => 2, :default => 0.0
    t.boolean "is_parent"
  end

  add_index "accounts", ["entity_id"], :name => "entity_id"
  add_index "accounts", ["name"], :name => "name"
  add_index "accounts", ["parent_id"], :name => "parent_id"

  create_table "combo_line_types", :id => false, :force => true do |t|
    t.integer "id"
    t.string  "name"
  end

  create_table "combo_lines", :force => true do |t|
    t.integer  "product_id"
    t.integer  "combo_id"
    t.decimal  "quantity",              :precision => 8, :scale => 2
    t.integer  "serialized_product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "combo_line_type_id"
  end

  create_table "costs", :force => true do |t|
    t.integer "product_id"
    t.integer "order_id"
    t.integer "entity_id"
    t.decimal "quantity",   :precision => 8, :scale => 2, :default => 0.0
    t.decimal "value",      :precision => 8, :scale => 2, :default => 0.0
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
    t.string   "next_receipt_number",      :limit => 8
    t.integer  "client_accounts_group_id"
    t.integer  "vendor_accounts_group_id"
    t.string   "next_bar_code",            :limit => 32
    t.string   "fax",                      :limit => 8
  end

  add_index "entities", ["entity_type_id"], :name => "entity_type_id"
  add_index "entities", ["name"], :name => "name"
  add_index "entities", ["site_id"], :name => "site_id"

  create_table "entity_types", :force => true do |t|
    t.string "name"
  end

  create_table "entries", :force => true do |t|
    t.integer  "post_id"
    t.integer  "account_id"
    t.decimal  "balance",    :precision => 8, :scale => 2
    t.datetime "created_at"
  end

  add_index "entries", ["account_id"], :name => "account_id"
  add_index "entries", ["created_at"], :name => "created_at"
  add_index "entries", ["post_id"], :name => "post_id"

  create_table "inventories", :force => true do |t|
    t.integer "product_id"
    t.integer "entity_id"
    t.decimal "min",                           :precision => 8, :scale => 2
    t.decimal "max",                           :precision => 8, :scale => 2
    t.decimal "to_order",                      :precision => 8, :scale => 2
    t.date    "created_at"
    t.date    "updated_at"
    t.decimal "quantity",                      :precision => 8, :scale => 2
    t.integer "default_warranty_sales_id"
    t.integer "default_warranty_purchases_id"
    t.decimal "cost",                          :precision => 8, :scale => 2
    t.decimal "default_cost",                  :precision => 8, :scale => 2
  end

  add_index "inventories", ["entity_id"], :name => "entity_id"
  add_index "inventories", ["product_id"], :name => "product_id"

  create_table "lines", :force => true do |t|
    t.integer  "product_id"
    t.integer  "order_id"
    t.decimal  "quantity",              :precision => 8, :scale => 2
    t.decimal  "price",                 :precision => 8, :scale => 2, :default => 0.0
    t.datetime "received"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "serialized_product_id"
    t.integer  "line_id"
    t.decimal  "warranty_price",        :precision => 8, :scale => 2, :default => 0.0
    t.integer  "warranty_id"
    t.decimal  "tax",                   :precision => 8, :scale => 2, :default => 0.0
    t.decimal  "previous_qty",          :precision => 8, :scale => 2
    t.integer  "warranty_months"
    t.integer  "receipt_id"
    t.text     "note"
    t.decimal  "sales_tax",             :precision => 8, :scale => 2, :default => 0.0
    t.integer  "order_type_id"
    t.decimal  "cost",                  :precision => 8, :scale => 2
    t.integer  "cost_ref"
  end

  add_index "lines", ["order_id"], :name => "order_id"
  add_index "lines", ["product_id"], :name => "product_id"

  create_table "logs", :force => true do |t|
    t.string   "severity",     :limit => 32
    t.datetime "created_at"
    t.string   "msg"
    t.string   "object_class", :limit => 32
    t.integer  "object_id"
  end

  create_table "movement_types", :force => true do |t|
    t.string "name"
  end

  create_table "movements", :force => true do |t|
    t.integer  "entity_id"
    t.integer  "product_id"
    t.decimal  "quantity",              :precision => 8, :scale => 2
    t.integer  "movement_type_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "order_id"
    t.integer  "serialized_product_id"
    t.text     "comments"
    t.integer  "line_id"
    t.decimal  "quantity_left",         :precision => 8, :scale => 2
    t.decimal  "cost",                  :precision => 8, :scale => 2
    t.integer  "cost_ref"
    t.decimal  "value_left",            :precision => 8, :scale => 2
  end

  add_index "movements", ["entity_id"], :name => "entity_id"
  add_index "movements", ["order_id"], :name => "order_id"
  add_index "movements", ["order_id"], :name => "order_id_2"
  add_index "movements", ["product_id"], :name => "product_id"

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
    t.decimal  "grand_total",                               :precision => 8, :scale => 2, :default => 0.0
    t.decimal  "amount_paid",                               :precision => 8, :scale => 2, :default => 0.0
    t.boolean  "d",                                                                       :default => false
    t.integer  "purchase_receipt_number"
    t.integer  "next_order"
    t.string   "receipt_filename"
    t.datetime "receipt_generated"
    t.string   "receipt_number",               :limit => 8
    t.integer  "scanned_receipt_id"
    t.string   "scanned_receipt_content_type"
    t.string   "scanned_receipt_file_name"
    t.integer  "scanned_receipt_file_size"
    t.integer  "sequel_id"
    t.integer  "prequel_id"
    t.date     "deleted_at"
  end

  add_index "orders", ["client_id"], :name => "client_id"
  add_index "orders", ["created_at"], :name => "created_at"
  add_index "orders", ["receipt_number"], :name => "receipt_number"
  add_index "orders", ["vendor_id"], :name => "vendor_id"

  create_table "payment_methods", :force => true do |t|
    t.string "name"
  end

  create_table "payments", :force => true do |t|
    t.integer  "order_id"
    t.integer  "payment_method_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.decimal  "returned",          :precision => 8, :scale => 2, :default => 0.0
    t.decimal  "presented",         :precision => 8, :scale => 2, :default => 0.0
    t.boolean  "canceled",                                        :default => false
  end

  add_index "payments", ["created_at"], :name => "created_at"
  add_index "payments", ["order_id"], :name => "order_id"

  create_table "post_types", :force => true do |t|
    t.string "name"
  end

  create_table "posts", :force => true do |t|
    t.integer  "post_type_id"
    t.decimal  "value",        :precision => 8, :scale => 2
    t.integer  "account_id"
    t.integer  "trans_id"
    t.decimal  "balance",      :precision => 8, :scale => 2
    t.datetime "created_at"
  end

  add_index "posts", ["account_id"], :name => "account_id"
  add_index "posts", ["created_at"], :name => "created_at"
  add_index "posts", ["trans_id"], :name => "trans_id"

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

  add_index "prices", ["price_group_id"], :name => "price_group_id"
  add_index "prices", ["product_id"], :name => "product_id"

  create_table "product_categories", :force => true do |t|
    t.string  "name",               :default => ""
    t.integer "revenue_account_id"
  end

  create_table "product_types", :force => true do |t|
    t.string "name"
  end

  create_table "production_order_lines", :force => true do |t|
    t.decimal "quantity",              :precision => 8, :scale => 2
    t.decimal "quantity_planned",      :precision => 8, :scale => 2
    t.integer "product_id"
    t.integer "production_order_id"
    t.integer "serialized_product_id"
    t.string  "type"
  end

  create_table "production_orders", :force => true do |t|
    t.string   "name",           :limit => 30,                                                  :null => false
    t.boolean  "is_process",                                                 :default => false
    t.datetime "created_at"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.integer  "created_by_id"
    t.integer  "started_by_id"
    t.integer  "finished_by_id"
    t.integer  "site_id"
    t.decimal  "quantity",                     :precision => 8, :scale => 2
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
    t.integer  "image_id"
    t.string   "image_content_type"
    t.string   "image_file_name"
    t.integer  "image_file_size"
  end

  add_index "products", ["name"], :name => "name"
  add_index "products", ["product_category_id"], :name => "product_category_id"
  add_index "products", ["product_type_id"], :name => "product_type_id"
  add_index "products", ["upc"], :name => "upc"
  add_index "products", ["vendor_id"], :name => "vendor_id"

  create_table "requirements", :force => true do |t|
    t.integer "product_id"
    t.integer "required_id"
    t.decimal "quantity",       :precision => 8, :scale => 2
    t.decimal "static_price",   :precision => 8, :scale => 2
    t.decimal "relative_price", :precision => 8, :scale => 2
  end

  create_table "rights", :force => true do |t|
    t.string "name"
  end

  add_index "rights", ["id"], :name => "id"

  create_table "rights_roles", :force => true do |t|
    t.integer "role_id"
    t.integer "right_id"
  end

  add_index "rights_roles", ["role_id"], :name => "role_id"

  create_table "roles", :force => true do |t|
    t.string "title"
  end

  create_table "roles_users", :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "roles_users", ["user_id"], :name => "user_id"

  create_table "schema_info", :id => false, :force => true do |t|
    t.integer "version"
  end

  create_table "serialized_products", :force => true do |t|
    t.string  "serial_number"
    t.integer "product_id"
  end

  add_index "serialized_products", ["product_id"], :name => "product_id"
  add_index "serialized_products", ["product_id"], :name => "product_id_2"
  add_index "serialized_products", ["product_id"], :name => "product_id_3"
  add_index "serialized_products", ["serial_number"], :name => "serial_number"
  add_index "serialized_products", ["serial_number"], :name => "serial_number_2"

  create_table "states", :force => true do |t|
    t.string "name"
  end

  create_table "subscriptions", :force => true do |t|
    t.string   "name"
    t.integer  "client_id"
    t.integer  "vendor_id"
    t.decimal  "quantity",        :precision => 8, :scale => 2, :default => 1.0
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

  add_index "subscriptions", ["client_id"], :name => "client_id"

  create_table "trans", :force => true do |t|
    t.integer  "order_id"
    t.text     "comments"
    t.datetime "created_at"
    t.integer  "user_id"
    t.string   "type"
    t.string   "description", :limit => 32
    t.integer  "payment_id"
    t.integer  "direction"
    t.integer  "kind_id"
  end

  add_index "trans", ["created_at"], :name => "created_at"
  add_index "trans", ["order_id"], :name => "order_id"
  add_index "trans", ["user_id"], :name => "user_id"

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

  add_index "users", ["login"], :name => "login"

  create_table "warranties", :force => true do |t|
    t.integer "product_id"
    t.decimal "price",         :precision => 8, :scale => 2
    t.integer "month_id"
    t.integer "order_type_id"
    t.integer "months"
  end

  add_index "warranties", ["product_id"], :name => "product_id"

  create_table "warranty_months", :force => true do |t|
    t.integer "months"
  end

end
