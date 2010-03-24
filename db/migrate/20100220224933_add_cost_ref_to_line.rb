class AddCostRefToLine < ActiveRecord::Migration
  def self.up
    add_column :lines, :cost_ref, :integer
    remove_column :lines, :movement_id
  end

  def self.down
    remove_column :lines, :cost_ref
    add_column :lines, :movement_id, :integer
  end
end
