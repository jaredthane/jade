class BaseContract < ActiveRecord::Base
	belongs_to :site
	belongs_to :completer, :class_name => "User", :foreign_key => 'completed_by'
	belongs_to :blocker, :class_name => "User", :foreign_key => 'blocked_by'
	belongs_to :creator, :class_name => "User", :foreign_key => 'created_by'
	belongs_to :updater, :class_name => "User", :foreign_key => 'updated_by'
end
