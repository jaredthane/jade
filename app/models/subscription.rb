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
	def create_order_for_client(subs)
	  puts "subs:" +  subs.inspect
	  for vendor_id, list in subs
	    puts "vendor_id=" + vendor_id.inspect
	    puts "list=" + list.inspect
	    o=Order.create(:vendor => list[0].vendor, :client => list[0].client,:user => User.current_user, :order_type_id => 1, :last_batch =>true)
	    for sub in list
	      l=Line.create(:order => o, :product => sub.product, :quantity=> sub.quantity, :price => sub.price)
	      puts "last order = " + sub.last_order.inspect
	      puts "o = " + o.inspect
	      puts "sub=" + sub.inspect
	      sub.last_order=o
	      puts "last order after= " + sub.last_order.inspect
        sub.save
	      puts "make sure it saved= " + Subscription.find(sub.id).last_order.inspect
      end
    end
	end
	
	###################################################################################
	# Returns the upc of the product requested
	###################################################################################
	def product_name
 	 product.name if product
	end
	
	###################################################################################
	# Sets the product requested by the upc provided
	###################################################################################
	def product_name=(name)
		if !name.blank?		
			prod = Product.find_by_name(name)
			if prod != nil
				self.product_id = prod.id
			end
		end
	end
	
	def create_orders
	  for o in Order.find(:all, :conditions =>'last_batch=True')
  		o.last_batch=false
  		o.save
  	end
  	for client in Entity.find_all_clients
  	  subs_to_fill_for_client = {}
  	  puts "asubs_to_fill_for_client" + subs_to_fill_for_client.inspect
  	  for sub in Subscription.find_all_by_client_id(client.id)
  	    if sub.last_order
	        if sub.last_order.created_at.to_date >> 1 < Date.today
  	        puts "bsubs_to_fill_for_client" + subs_to_fill_for_client.inspect
	          subs_to_fill_for_client[sub.vendor_id] = [] if !subs_to_fill_for_client[sub.vendor_id]
  	        puts "csubs_to_fill_for_client" + subs_to_fill_for_client.inspect
	          subs_to_fill_for_client[sub.vendor_id] << sub
	        end
	      else
	        if sub.created_at.to_date >> 1 < Date.today
	          puts "dsubs_to_fill_for_client" + subs_to_fill_for_client.inspect
	          subs_to_fill_for_client[sub.vendor_id] = [] if !subs_to_fill_for_client[sub.vendor_id]
    	      puts "esubs_to_fill_for_client" + subs_to_fill_for_client.inspect  
	          subs_to_fill_for_client[sub.vendor_id] << sub
          end
	      end
  	  end
  	  puts "fsubs_to_fill_for_client" + subs_to_fill_for_client.inspect
  	  puts "lenght="+subs_to_fill_for_client.length.to_s
  	  create_order_for_client(subs_to_fill_for_client) if subs_to_fill_for_client.length > 0
  	end
	end
	def self.search(search, page)
  	    paginate :per_page => 20, :page => page,
		         :conditions => ['(products.name like :search or products.upc like :search or clients.name like :search)', {:search => "%#{search}%"}],
		         :order => 'products.name',
		         :joins => 'inner join products on products.id = subscriptions.product_id inner join entities as clients on clients.id = subscriptions.client_id'
	end
	def price(price_group = User.current_user.current_price_group)
	    return (self.product.price||0) * (relative_price||0) + (fixed_price||0)
	end
end
