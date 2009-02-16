class ChangeUsers < ActiveRecord::Migration
  def self.up
  	add_column :users, :role_id, :int
  end

  def self.down
  end
end
