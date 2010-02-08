class ChangeQuantitiesToDecimal < ActiveRecord::Migration
  def self.up
  	change_column :inventories, :min, :decimal, :precision => 8, :scale => 2
  	change_column :inventories, :max, :decimal, :precision => 8, :scale => 2
  	change_column :inventories, :quantity, :decimal, :precision => 8, :scale => 2
  	change_column :combo_lines, :quantity, :decimal, :precision => 8, :scale => 2
  	change_column :inventories, :to_order, :decimal, :precision => 8, :scale => 2
  	change_column :lines, :quantity, :decimal, :precision => 8, :scale => 2
  	change_column :lines, :previous_qty, :decimal, :precision => 8, :scale => 2
  	change_column :movements, :quantity, :decimal, :precision => 8, :scale => 2
  	change_column :production_order_lines, :quantity, :decimal, :precision => 8, :scale => 2
  	change_column :production_order_lines, :quantity_planned, :decimal, :precision => 8, :scale => 2
  	change_column :production_orders, :quantity, :decimal, :precision => 8, :scale => 2
  	change_column :requirements, :quantity, :decimal, :precision => 8, :scale => 2
  	change_column :subscriptions, :quantity, :decimal, :precision => 8, :scale => 2
  	
  end

  def self.down
  	
  	change_column :inventories, :min, :integer
  	change_column :inventories, :max, :integer
  	change_column :inventories, :quantity, :integer
  	change_column :combo_lines, :quantity, :integer
  	change_column :inventories, :to_order, :integer
  	change_column :lines, :quantity, :integer
  	change_column :lines, :previous_qty, :integer
  	change_column :movements, :quantity, :integer
  	change_column :production_order_lines, :quantity, :integer
  	change_column :production_order_lines, :quantity_planned, :integer
  	change_column :production_orders, :quantity, :integer
  	change_column :requirements, :quantity, :integer
  	change_column :subscriptions, :quantity, :integer
  	
  end
end
