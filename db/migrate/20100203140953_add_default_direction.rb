class AddDefaultDirection < ActiveRecord::Migration
  def self.up
  	remove_column :movements, :direction
  	add_column :movements, :direction, :integer, :default=>1
  end

  def self.down
  	remove_column :movements, :direction
  	add_column :movements, :direction, :integer
  end
end
