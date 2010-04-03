class RenameProductionLineCost < ActiveRecord::Migration
  def self.up
    rename_column :production_order_lines, :cost, :_cost
  end

  def self.down
    rename_column :production_order_lines, :_cost, :cost
  end
end
