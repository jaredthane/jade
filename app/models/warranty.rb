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

class Warranty < ActiveRecord::Base
	has_many :lines
	belongs_to :product
	
	def self.search(search, page)
  	paginate :per_page => 20, :page => page,
		         :conditions => ['(products.name like :search or products.upc like :search)', {:search => "%#{search}%"}],
		         :order => 'products.name',
		         :joins => 'inner join products on products.id = warranties.product_id'
	end
end
