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

  create_table "combo_line_types", :force => true do |t|
    t.string "name"
  end

  create_table "combo_lines", :force => true do |t|
    t.integer  "product_id",            :limit => 11
    t.integer  "combo_id",              :limit => 11
    t.integer  "quantity_id",           :limit => 11
    t.integer  "serialized_product_id", :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "combo_line_type_id",    :limit => 11
  end

  create_table "entities", :force => true do |t|
    t.string   "name"
    t.integer  "entity_type_id", :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entity_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lines", :force => true do |t|
    t.integer  "product_id",            :limit => 11
    t.integer  "order_id",              :limit => 11
    t.integer  "quantity",              :limit => 11
    t.float    "price"
    t.date     "received"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "serialized_product_id", :limit => 11
  end

  create_table "movement_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "movements", :force => true do |t|
    t.integer  "entity_id",             :limit => 11
    t.integer  "product_id",            :limit => 11
    t.integer  "quantity",              :limit => 11
    t.integer  "movement_type_id",      :limit => 11
    t.integer  "user_id",               :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "order_id",              :limit => 11
    t.integer  "serialized_product_id", :limit => 11
  end

  create_table "orders", :force => true do |t|
    t.integer  "vendor_id",             :limit => 11
    t.integer  "client_id",             :limit => 11
    t.date     "received"
    t.date     "ordered"
    t.integer  "user_id",               :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "serialized_product_id", :limit => 11
  end

  create_table "payment_methods", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", :force => true do |t|
    t.integer  "order_id",          :limit => 11
    t.integer  "amount",            :limit => 11
    t.date     "date"
    t.integer  "payment_method_id", :limit => 11
    t.integer  "user_id",           :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "privileges", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "vendor_id",             :limit => 11
    t.integer  "min",                   :limit => 11
    t.integer  "max",                   :limit => 11
    t.float    "price"
    t.float    "cost"
    t.integer  "order",                 :limit => 11
    t.string   "upc"
    t.integer  "unit_id",               :limit => 11
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "model"
    t.boolean  "serialized"
    t.integer  "serialized_product_id", :limit => 11
    t.integer  "product_type_id",       :limit => 11
  end

  create_table "roles", :force => true do |t|
    t.string   "title"
    t.integer  "user_id",    :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", :force => true do |t|
    t.integer  "user_id",    :limit => 11
    t.integer  "role_id",    :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "serialized_products", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "serial_number", :limit => 11
    t.integer  "product_id",    :limit => 11
  end

  create_table "units", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_privileges", :force => true do |t|
    t.integer  "user_id",      :limit => 11
    t.integer  "privilege_id", :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.integer  "location_id",               :limit => 11
    t.integer  "role_id",                   :limit => 11
    t.boolean  "default_received"
  end

end
