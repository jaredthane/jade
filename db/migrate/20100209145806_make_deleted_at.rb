class MakeDeletedAt < ActiveRecord::Migration
  def self.up
  	add_column :orders, :deleted_at, :date
  	execute "UPDATE orders set deleted_at=#{Date.today} where deleted=1"
  	remove_column :orders, :deleted
  end

  def self.down
  	add_column :orders, :deleted, :integer, :default=>0
  	execute "UPDATE orders set deleted=1 where deleted_at is not null"
  	remove_column :orders, :deleted_at
  end
end
