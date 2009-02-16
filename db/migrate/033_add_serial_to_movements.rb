class AddSerialToMovements < ActiveRecord::Migration
  def self.up
   	add_column :movements, :serialized_product_id, :int
  end

  def self.down
  end
end
