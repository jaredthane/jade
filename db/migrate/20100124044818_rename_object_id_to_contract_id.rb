class RenameObjectIdToContractId < ActiveRecord::Migration
  def self.up
  	rename_column :movements, :object_id, :contract_id
  end

  def self.down
  	rename_column :movements, :contract_id, :object_id
  end
end
