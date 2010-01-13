class DoStiOnProduction < ActiveRecord::Migration
  def self.up
  	rename_table :prod_orders, :production_orders
  	rename_table :prod_lines, :production_lines
  	add_column :production_lines, :type, :string, {:limit=>30}
	end
  def self.down
  	rename_table :production_orders, :prod_orders
  	rename_table :production_lines, :prod_lines
  	remove_column :production_lines, :type
  end
end
