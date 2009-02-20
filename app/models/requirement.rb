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

class Requirement < ActiveRecord::Base
	belongs_to :product
	belongs_to :required, :class_name => "Product", :foreign_key => 'required_id'
	def bar_code
 	 required.upc if required
	end
	def bar_code=(upc)
		unless upc.blank?
			if product=Product.find_by_upc(upc)
				self.required_id = Product.find_by_upc(upc).id
			end
		end
	end
	def price(price_group = User.current_user.current_price_group)
		if required
			return ((required.price(price_group)||0) * (self.relative_price||0) + (self.static_price||0)) * (self.quantity||0)
		else
			return ( (self.relative_price||0) + (self.static_price||0)) * (self.quantity||0)
		end
	end
end
