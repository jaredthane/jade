class Movement < ActiveRecord::Base
	belongs_to :contract, :class_name => "BaseContract", :foreign_key => 'object_id'
	belongs_to :blocker, :class_name => "User", :foreign_key => 'blocked_by'
	belongs_to :creator, :class_name => "User", :foreign_key => 'created_by'
	
	has_many :entries, :dependent => :destroy
	accepts_nested_attributes_for :entries, :allow_destroy => true
  validates_associated :entries
end
