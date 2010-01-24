class Account < ActiveRecord::Base
	has_many :entries, :dependent => :destroy
	belongs_to :parent, :class_name => "Account"
	belongs_to :blocker, :class_name => "User", :foreign_key => 'blocked_by'
end
