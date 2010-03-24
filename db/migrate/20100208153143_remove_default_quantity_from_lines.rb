class RemoveDefaultQuantityFromLines < ActiveRecord::Migration
  def self.up
  	change_column :lines, :quantity, :integer, :default=>nil
  end

  def self.down
  	change_column :lines, :quantity, :integer, :default=>0
  end
end
