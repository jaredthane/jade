class CreateWarranties < ActiveRecord::Migration
  def self.up
    create_table :warranties do |t|
    t.string "product_id"
    t.decimal "price",         :precision => 8, :scale => 2
    t.integer "order_type"
    t.integer "months"
    end
  end

  def self.down
    drop_table :warranties
  end
end
