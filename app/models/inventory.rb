class Inventory < ActiveRecord::Base
	belongs_to :product
	belongs_to :entity
	belongs_to :default_sales_warranty
	belongs_to :default_purchase_warranty
	belongs_to :blocker, :class_name => "User", :foreign_key => 'blocked_by'
end
