class AddEmployeeAccountsGroupToEntities < ActiveRecord::Migration
  def self.up
  	add_column :entities, :employee_accounts_group_id, :integer
  end

  def self.down
  	remove_column :entities, :employee_accounts_group_id, :integer
  end
end
