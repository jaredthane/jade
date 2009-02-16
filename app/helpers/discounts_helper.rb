module DiscountsHelper
	def edit_discount_path(discount)
		return '/discounts/' + discount.id.to_s + '/edit'
	end
	def fields_for_requirement(requirement, &block)
		prefix = requirement.new_record? ? 'new' : 'existing'
		fields_for("product[#{prefix}_requirement_attributes][]", requirement, &block)
	end

	def add_requirement_link(name) 
		link_to_function name do |page| 
		  page.insert_html :bottom, :requirements, :partial => 'requirement', :object => Requirement.new 
		end 
	end 
end
