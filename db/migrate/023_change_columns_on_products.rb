class ChangeColumnsOnProducts < ActiveRecord::Migration
  def self.up
  	remove_column :products, :serial
  	add_column :products, :serialized_product_id, :int
		rename_column :products, :has_serial, :serialized
  end

  def self.down
  end
end
