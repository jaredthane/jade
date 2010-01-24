class AddEntitiesToBaseContract < ActiveRecord::Migration
  def self.up
  	add_column :base_contracts, :entityA_id, :integer
  	add_column :base_contracts, :entityB_id, :integer
  end

  def self.down
  	remove_column :base_contracts, :entityA_id
  	remove_column :base_contracts, :entityB_id
  end
end
