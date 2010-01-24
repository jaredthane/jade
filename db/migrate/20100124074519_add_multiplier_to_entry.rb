class AddMultiplierToEntry < ActiveRecord::Migration
  def self.up
  	add_column :entries, :multiplier, :integer
  end

  def self.down
  	remove_column :entries, :multiplier
  end
end
