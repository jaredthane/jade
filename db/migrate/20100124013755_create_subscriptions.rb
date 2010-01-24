class CreateSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :subscriptions do |t|
    t.string   "name"
    t.integer  "client_id"
    t.integer  "vendor_id"
    t.integer  "quantity",                                      :default => 1
    t.datetime "end_date"
    t.integer  "end_times"
    t.decimal  "fixed_price",     :precision => 8, :scale => 2, :default => 0.0
    t.decimal  "relative_price",  :precision => 8, :scale => 2, :default => 0.0
    t.string  "product_id"
    t.integer  "frequency",                                     :default => 1
    t.datetime "created_at"
    t.datetime "next_date"
    end
  end

  def self.down
    drop_table :subscriptions
  end
end
