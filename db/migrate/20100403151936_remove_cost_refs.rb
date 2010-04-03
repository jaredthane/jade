class RemoveCostRefs < ActiveRecord::Migration
  def self.up
    remove_column :lines, :cost_ref
    remove_column :costs, :order_id
  end

  def self.down
    add_column :lines, :cost_ref, :integer
    add_column :costs, :order_id, :integer
  end
end
