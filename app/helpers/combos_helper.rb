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


module CombosHelper
	def edit_combo_path(combo)
		return '/combos/' + combo.id.to_s + '/edit'
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
