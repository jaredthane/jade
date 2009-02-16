class AddOrderToMovements < ActiveRecord::Migration
  def self.up
   	add_column :movements, :order_id, :int
   	remove_column :movements, :date
  end

  def self.down
  end
end
