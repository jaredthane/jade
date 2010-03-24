class AddFieldsToMovements < ActiveRecord::Migration
  def self.up
    add_column :movements, :quantity_left, :decimal, :precision => 8, :scale => 2
    add_column :movements, :cost, :decimal, :precision => 8, :scale => 2
    add_column :movements, :cost_ref, :integer
    add_column :movements, :value_left, :decimal, :precision => 8, :scale => 2
  end

  def self.down
    remove_column :movements, :quantity_left
    remove_column :movements, :cost
    remove_column :movements, :cost_ref
    remove_column :movements, :value_left
  end
end

