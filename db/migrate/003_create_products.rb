class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string :name
      t.text :description
      t.references :vendor
      t.integer :min
      t.integer :max
      t.float :price
      t.float :cost
      t.integer :order
      t.string :upc
      t.references :unit
      t.string :location

      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
