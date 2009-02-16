class AddTypeToProducts < ActiveRecord::Migration
  def self.up
   	add_column :products, :type_id, :int
  end

  def self.down
  end
end
