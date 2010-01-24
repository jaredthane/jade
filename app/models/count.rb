class Count < BaseContract
	has_attached_file :document
	
	
	has_many :count_lines, :dependent => :destroy
	accepts_nested_attributes_for :count_lines, :allow_destroy => true
  validates_associated :count_lines
end