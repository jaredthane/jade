class AddFieldsToUser < ActiveRecord::Migration
  def self.up
  	add_column :users, :location_id, :int
  end

  def self.down
  end
end
