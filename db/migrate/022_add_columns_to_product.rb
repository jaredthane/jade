class AddColumnsToProduct < ActiveRecord::Migration
  def self.up
  	add_column :products, :model, :string
  	add_column :products, :serial, :string
  	add_column :products, :has_serial, :boolean
  end

  def self.down
  end
end
