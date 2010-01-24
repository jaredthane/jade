class CreateInventories < ActiveRecord::Migration
  def self.up
    create_table :inventories do |t|
      t.string :product_id
      t.integer :entity_id
      t.integer :min
      t.integer :max
      t.integer :to_order
      t.integer :quantity
      t.integer :default_sales_warranty_id
      t.integer :default_purchase_warrany_id
      t.decimal :cost
      t.decimal :default_cost
      t.integer :blocked_by
    end
  end

  def self.down
    drop_table :inventories
  end
end
