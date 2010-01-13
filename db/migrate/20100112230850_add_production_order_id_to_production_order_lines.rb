class AddProductionOrderIdToProductionOrderLines < ActiveRecord::Migration
  def self.up
  	rename_column :production_order_lines, :prod_order_id, :production_order_id
  end

  def self.down
  end
end
