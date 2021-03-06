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

class Inventory < ActiveRecord::Base
	belongs_to :entity
	belongs_to :product
	def on_order()
		list=self.product.lines.find(:all, :conditions => 'orders.order_type_id=2 AND orders.deleted=0 AND lines.received is null AND orders.client_id=' + entity_id.to_s, :joins => 'left join orders on orders.id=lines.order_id')
		return list.sum(&:quantity)
	end
	def sales_waiting()
		list=self.product.lines.find(:all, :conditions => 'orders.order_type_id=1 AND orders.deleted=0 AND lines.received is null AND orders.vendor_id=' + entity_id.to_s, :joins => 'left join orders on orders.id=lines.order_id')
		return list.sum(&:quantity)
	end
	def self.search(search, page)
		search = (search ||"")
		if search[0..3].downcase=='rojo'
			joins = 'inner join products on products.id = inventories.product_id inner join entities on entities.id = inventories.entity_id left join (SELECT `lines`.product_id, sum(`lines`.quantity) as quantity FROM `lines` left join orders on orders.id=lines.order_id WHERE orders.order_type_id=1 AND orders.vendor_id=' + User.current_user.location_id.to_s + ' AND lines.received is null GROUP BY `lines`.product_id) as sales on sales.product_id = products.id left join (SELECT `lines`.product_id, sum(`lines`.quantity) as quantity FROM `lines` left join orders on orders.id=lines.order_id WHERE orders.order_type_id=2  AND orders.client_id=' + User.current_user.location_id.to_s + ' AND lines.received is null GROUP BY `lines`.product_id) as purchases on purchases.product_id = products.id'
			search = search[4..search.length].downcase.strip
			paginate :per_page => 20, :page => page,                                                                                                                     
				:conditions => ['(products.name like :search OR products.upc like :search) AND (entities.id=:current_location) AND (products.product_type_id=1) AND (COALESCE(inventories.quantity,0) + COALESCE(purchases.quantity,0) < COALESCE(sales.quantity,0) + COALESCE(inventories.min,0)) AND (inventories.to_order=0 OR inventories.to_order is null)', {:search => "%#{search}%", :current_location => "#{User.current_user.location_id}"}],
				:order => 'inventories.created_at DESC',
				:joins => joins
		elsif search[0..4].downcase=='verde'
			search = search[5..search.length].downcase.strip
			paginate :per_page => 20, :page => page,
				:conditions => ['(products.name like :search OR products.upc like :search) AND (entities.id=:current_location) AND (products.product_type_id=1) AND (inventories.to_order > 0)', {:search => "%#{search}%", :current_location => "#{User.current_user.location_id}"}],
				:order => 'inventories.created_at DESC',
				:joins => 'inner join products on products.id = inventories.product_id inner join entities on entities.id = inventories.entity_id'
		else	       
			paginate :per_page => 20, :page => page,
				:conditions => ['(products.name like :search OR products.upc like :search) AND (entities.id=:current_location) AND (products.product_type_id=1)', {:search => "%#{search}%", :current_location => "#{User.current_user.location_id}"}],
				:order => 'inventories.created_at DESC',
				:joins => 'inner join products on products.id = inventories.product_id inner join entities on entities.id = inventories.entity_id'
		end
	end
	def self.search_wo_pagination(search)
		search = (search ||"")
		if search[0..3].downcase=='rojo'
			joins = 'inner join products on products.id = inventories.product_id inner join entities on entities.id = inventories.entity_id left join (SELECT `lines`.product_id, sum(`lines`.quantity) as quantity FROM `lines` left join orders on orders.id=lines.order_id WHERE orders.order_type_id=1 AND orders.vendor_id=' + User.current_user.location_id.to_s + ' AND lines.received is null GROUP BY `lines`.product_id) as sales on sales.product_id = products.id left join (SELECT `lines`.product_id, sum(`lines`.quantity) as quantity FROM `lines` left join orders on orders.id=lines.order_id WHERE orders.order_type_id=2  AND orders.client_id=' + User.current_user.location_id.to_s + ' AND lines.received is null GROUP BY `lines`.product_id) as purchases on purchases.product_id = products.id'
			search = search[4..search.length].downcase.strip
			find :all,
				:conditions => ['(products.name like :search OR products.upc like :search) AND (entities.id=:current_location) AND (products.product_type_id=1) AND (COALESCE(inventories.quantity,0) + COALESCE(purchases.quantity,0) < COALESCE(sales.quantity,0) + COALESCE(inventories.min,0)) AND (inventories.to_order=0 OR inventories.to_order is null)', {:search => "%#{search}%", :current_location => "#{User.current_user.location_id}"}],
				:order => 'inventories.created_at DESC',
				:joins => joins
		elsif search[0..4].downcase=='verde'
			search = search[5..search.length].downcase.strip
			find :all,
				:conditions => ['(products.name like :search OR products.upc like :search) AND (entities.id=:current_location) AND (products.product_type_id=1) AND (inventories.to_order > 0)', {:search => "%#{search}%", :current_location => "#{User.current_user.location_id}"}],
				:order => 'inventories.created_at DESC',
				:joins => 'inner join products on products.id = inventories.product_id inner join entities on entities.id = inventories.entity_id'
		else	       
			find :all,
				:conditions => ['(products.name like :search OR products.upc like :search) AND (entities.id=:current_location) AND (products.product_type_id=1)', {:search => "%#{search}%", :current_location => "#{User.current_user.location_id}"}],
				:order => 'inventories.created_at DESC',
				:joins => 'inner join products on products.id = inventories.product_id inner join entities on entities.id = inventories.entity_id'
		end
	end
#	def self.search_wo_pagination(search, page)
#		find     	:all, 
#							:conditions => ['(products.name like :search OR products.upc like :search) AND (entities.id=:current_location) AND (products.product_type_id=1)', {:search => "%#{search}%", :current_location => "#{User.current_user.location_id}"}],
#			       	:order => 'inventories.created_at DESC',
#			      	:joins => 'inner join products on products.id = inventories.product_id inner join entities on entities.id = inventories.entity_id'
#	end
	def self.search_all_wo_pagination(search, page)
		find    	:all,  
							:conditions => ['(products.name like :search OR products.upc like :search) AND (products.product_type_id=1)', {:search => "%#{search}%"}],
			       	:order => 'inventories.created_at DESC',
			       	:joins => 'inner join products on products.id = inventories.product_id inner join entities on entities.id = inventories.entity_id'
	end
end
