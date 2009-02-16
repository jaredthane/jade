class CreateLines < ActiveRecord::Migration
  def self.up
    create_table :lines do |t|
      t.references :product
      t.references :order
      t.integer :quantity
      t.float :price
      t.date :received

      t.timestamps
    end
  end

  def self.down
    drop_table :lines
  end
end
