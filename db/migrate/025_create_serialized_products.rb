class CreateSerializedProducts < ActiveRecord::Migration
  def self.up
    create_table :serialized_products do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :serialized_products
  end
end
