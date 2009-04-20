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

class Price < ActiveRecord::Base
	belongs_to :price_groups
	belongs_to :product
	def available_str
		logger.debug "self.available=#{self.available.to_s}"
		if self.available == true
			logger.debug "giving si"
			return "Si"
		else
		logger.debug "giving no"
			return "No"
		end
	end
	def available_str=(str)
		logger.debug "str=#{str.to_s}"
		if str=="" or str=="no" or str=="No" or str=="NO"
			logger.debug "setting to no"
			self.available = 0
		else
			logger.debug "setting to yes"
			self.available = 1
		end
	end
	def self.search(search, page)
		paginate :per_page => 20, :page => page,
	       :conditions => ['(products.name like :search 
							OR products.description like :search 
							OR products.upc = :exact_search
							OR vendors.name like :search )
							AND (prices.price_group_id = :price_group_id)',
                            {:search => "%#{search}%", 
                            :exact_search => "#{search}", 
                            :price_group_id => User.current_user.current_price_group.id}],
	       :order => 'products.name',
	       :joins => 'inner join products on products.id = prices.product_id left join entities as vendors on vendors.id = products.vendor_id'
	end
end

