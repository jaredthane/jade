class ChangeColumnsOnOrders < ActiveRecord::Migration
  def self.up
  	add_column :orders, :serialized_product_id, :int
  end

  def self.down
  end
end
