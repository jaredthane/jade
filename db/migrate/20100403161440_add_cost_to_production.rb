class AddCostToProduction < ActiveRecord::Migration
  def self.up
    add_column :production_order_lines, :cost, :decimal, :precision => 8, :scale => 2
  end

  def self.down
    remove_column :production_order_lines, :cost
  end
end
