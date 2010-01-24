class AddNewAccountParentsToEntities < ActiveRecord::Migration
  def self.up
  	add_column :entities, :new_client_accounts_parent_id, :integer
  	add_column :entities, :new_vendor_accounts_parent_id, :integer
  	add_column :entities, :new_employee_accounts_parent_id, :integer
  end

  def self.down
  	remove_column :entities, :new_client_accounts_parent_id
  	remove_column :entities, :new_vendor_accounts_parent_id
  	remove_column :entities, :new_employee_accounts_parent_id
  end
end
