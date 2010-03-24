class AddProductionTables < ActiveRecord::Migration
  def self.up
  	create_table :production_order_lines  do |t|
      t.integer :quantity
      t.integer :quantity_planned
      t.integer :product_id
      t.integer :production_order_id
      t.integer :serialized_product_id
      t.string :type
  	end
  	create_table :production_orders  do |t|
      t.string :name,         :limit   => 30, :null => false
      t.boolean :is_process,     :default => 0
      t.datetime :created_at
      t.datetime :started_at
      t.datetime :finished_at
      t.integer :created_by_id
      t.integer :started_by_id
      t.integer :finished_by_id
      t.integer :site_id
      t.integer :quantity
    end
  end

  def self.down
  	drop_table :production_orders
  	drop_table :production_order_lines
  end
end
