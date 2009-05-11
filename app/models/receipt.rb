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

class Receipt < ActiveRecord::Base
	belongs_to :user
	belongs_to :order
	has_many :lines
	###################################################################################
	# Returns the total price of all of the products in the order, not including tax
	###################################################################################
	def total_price
		total=0
		for l in self.lines
			total = (total||0) + (l.total_price||0)
		end
		return (total||0)
	end
  ###################################################################################
	# Returns the total cost of all of the products in the order
	###################################################################################
	def total_cost
		total=0
		for l in self.lines
			total = (total||0) + (l.total_cost||0)
		end
		return (total||0)
	end
	###################################################################################
	# Returns the total tax to be charged the user.
	###################################################################################
	def total_tax
		total=0
		for l in self.lines
			total = (total||0) + (l.tax||0)
		end
		return (total||0)
	end
	
	###################################################################################
	# Returns the total price of all of the products in the order plus tax
	###################################################################################
	def total_price_with_tax
		total=0
		if order.client
			if order.client.entity_type_id == 2
				for l in self.lines
					total = (total||0) + (l.total_price||0)
				end
			else
				for l in self.lines
					total = (total||0) + (l.total_price_with_tax||0)
				end
			end
		else
			for l in self.lines
				total = (total||0) + (l.total_price||0)
			end
		end
		return (total||0)
	end
end
