class CreateMovements < ActiveRecord::Migration
  def self.up
    create_table :movements do |t|
      t.references :entity
      t.references :product
      t.integer :quantity
      t.references :movement_type
      t.references :user
      t.date :date

      t.timestamps
    end
  end

  def self.down
    drop_table :movements
  end
end
