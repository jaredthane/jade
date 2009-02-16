class AddDefaultReceived < ActiveRecord::Migration
  def self.up
   	add_column :users, :default_received, :boolean
  end

  def self.down
  end
end
