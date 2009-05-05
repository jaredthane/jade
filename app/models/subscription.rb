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

class Subscription < ActiveRecord::Base
	belongs_to :client, :class_name => "Entity", :foreign_key => "client_id"
	belongs_to :vendor, :class_name => "Entity", :foreign_key => "vendor_id"
	belongs_to :product
	belongs_to :last_order, :class_name => "Order", :foreign_key => "last_order_id"
	def client_name
 		client.name if client
	end
	def client_name=(name)
		self.client = Entity.find_by_name(name) unless name.blank?
	end
	def self.search(search, page)
  	    paginate :per_page => 20, :page => page,
		         :conditions => ['(products.name like :search or products.upc like :search or clients.name like :search)', {:search => "%#{search}%"}],
		         :order => 'products.name',
		         :joins => 'inner join products on products.id = subscriptions.product_id inner join entities as clients on clients.id = subscriptions.client_id'
	end
	def price(price_group = User.current_user.current_price_group)
	    return self.product.price * relative_price + fixed_price
	end
end
