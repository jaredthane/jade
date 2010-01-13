class AddProduction < ActiveRecord::Migration
  def self.up
  	create_table :prod_lines do |t|
  		t.integer :prod_order_id
  		t.integer :quantity
  		t.integer :product_id
  		t.boolean :is_output
		end
  	create_table :prod_order do |t|
  		t.string :name
  		t.datetime :created_at
  		t.datetime :started_at
  		t.datetime :finished_at
  		t.integer :quantity
  		t.boolean :is_model
		end
  end

  def self.down
  	drop_table :prod_lines
  	drop_table :prod_order
  end
end
