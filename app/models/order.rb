class Order < BaseContract
	has_attached_file :document
	
	has_many :order_lines, :dependent => :destroy
	accepts_nested_attributes_for :order_lines, :allow_destroy => true
  validates_associated :order_lines
end
