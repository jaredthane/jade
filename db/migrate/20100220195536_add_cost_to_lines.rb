class AddCostToLines < ActiveRecord::Migration
  def self.up
    add_column :lines, :cost, :decimal, :precision => 8, :scale => 2
  end

  def self.down
    drop_column :lines, :cost
  end
end
