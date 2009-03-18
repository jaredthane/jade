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

class PhysicalaCount < ActiveRecord::Base
	belongs_to :entity
	belongs_to :user
	has_many :physical_count_lines
	
#	def update( attributes, existing_lines = [], new_lines = [])
#		lines_to_delete=[]
#		# Check to see if each of our lines are in the list
#		for l in self.physical_count_lines
#			if existing_lines[l.id.to_s]
#				# If it is, save the changes
#				l.attributes = existing_lines[l.id.to_s]
#			else
#				# Otherwise put it on the hit list
#				lines_to_delete << l
#			end
#		end
#		
#		# delete the lines in the hit list
#		for l in lines_to_delete
#			self.physical_count_lines.delete(l)
#		end
#		
#		# Add the new lines
#  	for l in new_lines
#  		new_line = PhysicalCountLine.new(:physical_count_id=>self.id)
#  		# Make sure we set these values first just in case we want to submit this line later
#  		new_line.product_id = l[:product_id]		
#  		new_line.count = l[:count]
#  		# Now we can save the other values with confidence
#  		new_line.attributes=l  
#  		logger.debug "about to push #{new_line.inspect}"  	
#  		self.lines.push(new_line)
#  	end
#  	self.update_attributes(attributes)
#		
#	end
	def self.search(search, page)
  	paginate :per_page => 20, :page => page
	end
end
