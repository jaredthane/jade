class AddFieldsToProductions < ActiveRecord::Migration
  def self.up
  	add_column :production_orders, :created_by, :integer
  	add_column :production_orders, :started_by, :integer
  	add_column :production_orders, :finished_by, :integer
  end

  def self.down
  	drop_column :production_orders, :created_by
  	drop_column :production_orders, :started_by
  	drop_column :production_orders, :finished_by
  end
end
