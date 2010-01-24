class BaseProduct < ActiveRecord::Base
	belongs_to :unit
	belongs_to :blocker, :class_name => "User", :foreign_key => 'blocked_by'
	belongs_to :category
	belongs_to :revenue_account, :class_name => "Account"
end
