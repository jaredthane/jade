class AddPriceToMovements < ActiveRecord::Migration
  def self.up
    add_column :movements, :price, :decimal, :precision => 8, :scale => 2, :default => 0.0
  end

  def self.down
    remove_column :movements, :price
  end
end
