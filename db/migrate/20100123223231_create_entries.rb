class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table :entries do |t|
      t.integer :movement_id
      t.decimal :value
      t.integer :account_id
      t.decimal :balance
      t.string :product_id
      t.integer :quantity
      t.string :serial_id
      t.integer :entity_id
      t.integer :stock

      t.timestamps
    end
  end

  def self.down
    drop_table :entries
  end
end
