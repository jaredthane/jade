module EntitiesHelper
def fields_for_movement(movement, &block)
		prefix = movement.new_record? ? 'new' : 'existing'
		fields_for("entity[#{prefix}_movement_attributes][]", movement, &block)
	end

	def add_movement_link(name) 
		link_to_function name do |page| 
		  page.insert_html :bottom, "movements", :partial => 'movement', :object => Movement.new 
		end 
	end 
end
