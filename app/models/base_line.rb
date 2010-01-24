class BaseLine < ActiveRecord::Base
	belongs_to :product
	belongs_to :completer, :class_name => "User", :foreign_key => 'completed_by'
	belongs_to :serial
end
