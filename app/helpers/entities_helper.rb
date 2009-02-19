# Jade Inventory Control System
#Copyright (C) 2009  Jared T. Martin

#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.

#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.

#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

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
	def allowed(entity_type)
		case entity_type
			when 1
		  	return true if current_user.has_rights(['admin','compras','gerente'])
		  when 2
		  	return true if current_user.has_rights(['admin','gerente','ventas'])
		  when 3
		  	return true if current_user.has_rights(['admin','compras','gerente','ventas'])
		  when 5
		  	return true if current_user.has_rights(['admin','gerente','ventas'])
		  else 
		  	return false
		end
	end
end
