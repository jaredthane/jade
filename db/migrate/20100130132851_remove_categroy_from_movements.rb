class RemoveCategroyFromMovements < ActiveRecord::Migration
  def self.up
  	remove_column :movements, :category
  end

  def self.down
  	add_column :movements, :category, :string
  end
end
