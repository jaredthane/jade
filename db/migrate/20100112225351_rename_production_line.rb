class RenameProductionLine < ActiveRecord::Migration
  def self.up	
  	rename_table :production_lines, :production_order_lines
  end

  def self.down
  	rename_table :production_order_lines, :production_lines
  end
end
