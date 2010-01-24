class ChangeEntitiesOnBaseContract < ActiveRecord::Migration
  def self.up
  	rename_column :base_contracts, :entityA_id, :vendor_id
  	rename_column :base_contracts, :entityB_id, :client_id
  end

  def self.down
  	rename_column :base_contracts, :vendor_id, :entityA_id
  	rename_column :base_contracts, :client_id, :entityB_id
  end
end
