class DropPayablesFromEntities < ActiveRecord::Migration
  def self.up
  	remove_column :entities, :payables_account_id
  end

  def self.down
  	add_column :entities, :payables_account_id, :integer
  end
end
