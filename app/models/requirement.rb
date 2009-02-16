class Requirement < ActiveRecord::Base
	belongs_to :product
	belongs_to :required, :class_name => "Product", :foreign_key => 'required_id'
	def bar_code
 	 required.upc if required
	end
	def bar_code=(upc)
		self.required_id = Product.find_by_upc(upc).id unless upc.blank?
	end
end
