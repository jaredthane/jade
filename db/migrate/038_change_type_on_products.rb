class ChangeTypeOnProducts < ActiveRecord::Migration
  def self.up
   	remove_column :products, :type_id
   	add_column :products, :product_type_id, :int
  end

  def self.down
  end
end