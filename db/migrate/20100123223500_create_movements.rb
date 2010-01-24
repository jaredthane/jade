class CreateMovements < ActiveRecord::Migration
  def self.up
    create_table :movements do |t|
      t.integer :object_id
      t.integer :created_by
      t.datetime :created_at
      t.text :comments
      t.string :type
      t.integer :direction
      t.string :category
    end
  end

  def self.down
    drop_table :movements
  end
end
