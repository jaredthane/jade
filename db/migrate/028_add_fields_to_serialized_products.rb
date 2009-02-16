class AddFieldsToSerializedProducts < ActiveRecord::Migration
  def self.up
  	add_column :serialized_products, :serial_number, :int  	
  	add_column :serialized_products, :product_id, :int
  end

  def self.down
  end
end
