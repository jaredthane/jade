class CreateBaseLines < ActiveRecord::Migration
  def self.up
    create_table :base_lines do |t|
      t.string :product_id
      t.integer :parent_id
      t.integer :quantity
      t.decimal :value1
      t.decimal :value2
      t.datetime :completed_at
      t.integer :completed_by
      t.string :serial_number_id
      t.text :comments
      t.string :type
      
      # For Physical Counts
      t.integer :old_qty
    end
  end

  def self.down
    drop_table :base_lines
  end
end
