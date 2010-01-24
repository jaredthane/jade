class Site < Entity
	belongs_to :price_set
	belongs_to :user
	belongs_to :site
	
	belongs_to :inventory_account, :class_name => "Account", :foreign_key => "inventory_account_id"
	belongs_to :expense_account, :class_name => "Account", :foreign_key => "expense_account_id"
	belongs_to :returns_account, :class_name => "Account", :foreign_key => "expense_account_id"
	belongs_to :discounts_account, :class_name => "Account", :foreign_key => "expense_account_id"
	
	belongs_to :new_client_accounts_parent, :class_name => "Account", :foreign_key => "new_individual_client_accounts_parent_id"
	belongs_to :new_vendor_accounts_parent, :class_name => "Account", :foreign_key => "new_vendor_accounts_parent_id"
	belongs_to :new_employee_accounts_parent, :class_name => "Account", :foreign_key => "new_employee_accounts_parent_id"
	
	belongs_to :client_accounts_group, :class_name => "Account", :foreign_key => "client_accounts_group_id"
	belongs_to :vendor_accounts_group, :class_name => "Account", :foreign_key => "vendor_accounts_group_id"
	belongs_to :employee_accounts_group, :class_name => "Account", :foreign_key => "employee_accounts_group_id"
end
