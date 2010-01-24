class Entity < ActiveRecord::Base
	belongs_to :state
	belongs_to :tax_group
	belongs_to :cash_account, :class_name => "Account", :foreign_key => "cash_account_id"
	belongs_to :revenue_account, :class_name => "Account", :foreign_key => "revenue_account_id"
	belongs_to :blocker, :class_name => "User", :foreign_key => 'blocked_by'
	belongs_to :tax_account, :class_name => "Account", :foreign_key => "tax_account_id"
end
