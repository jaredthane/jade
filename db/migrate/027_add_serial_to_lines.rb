class AddSerialToLines < ActiveRecord::Migration
  def self.up
  	add_column :lines, :serialized_product_id, :int
  end

  def self.down
  end
end
