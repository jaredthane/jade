class AddBlockedBy < ActiveRecord::Migration
  def self.up
  	add_column :base_products, :blocked_by, :integer
  	add_column :base_contracts, :blocked_by, :integer
  	add_column :accounts, :blocked_by, :integer
  	add_column :movements, :blocked_by, :integer
  	add_column :entities, :blocked_by, :integer
  end

  def self.down
  	remove_column :base_products, :blocked_by
  	remove_column :base_contracts, :blocked_by
  	remove_column :accounts, :blocked_by
  	remove_column :movements, :blocked_by
  	remove_column :entities, :blocked_by
  end
end
