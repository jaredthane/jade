class CreateCosts < ActiveRecord::Migration
  def self.up
    create_table :costs do |t|
        t.integer :product_id
        t.integer :order_id
        t.integer :entity_id
        t.decimal :quantity,                 :precision => 8, :scale => 2, :default => 0.0
        t.decimal :value,                 :precision => 8, :scale => 2, :default => 0.0
    end
  end

  def self.down
    drop_table :costs
  end
end
