class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
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
  end

  def self.down
    drop_table :users
  end
end
