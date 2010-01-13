class RenameProdOrders < ActiveRecord::Migration
  def self.up
  	rename_table :prod_order, :prod_orders
  end

  def self.down
  	rename_table :prod_orders, :prod_order
  end
end
