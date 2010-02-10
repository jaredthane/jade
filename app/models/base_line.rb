# Jade Inventory Control System
# Copyright (C) 2009  Jared T. Martin

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
class BaseLine < ActiveRecord::Base
	belongs_to :product
	belongs_to :parent
	belongs_to :completer, :class_name => "User", :foreign_key => 'completed_by'
	belongs_to :serial
	
	###################################################################################
	# Returns the total price of the products on this line
	###################################################################################
	def total_cost
		return (product.cost ||0) * quantity
	end
  ###################################################################################
	# Returns the total price of the products on this line
	###################################################################################
	def total_price
		return ((price ||0) * (quantity || 0)
	end
end
