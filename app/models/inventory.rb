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
	def self.search(search, page)
		search = (search ||"")
		if search[0..3].downcase=='rojo'
			search = search[4..search.length].downcase.strip
			paginate :per_page => 20, :page => page,
				:conditions => ['(products.name like :search OR products.upc like :search) AND (entities.id=:current_location) AND (products.product_type_id=1) AND (inventories.quantity<inventories.min) AND (inventories.to_order=0 OR inventories.to_order is null)', {:search => "%#{search}%", :current_location => "#{User.current_user.location_id}"}],
				:order => 'inventories.created_at DESC',
				:joins => 'inner join products on products.id = inventories.product_id inner join entities on entities.id = inventories.entity_id'
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
	def self.search_wo_pagination(search, page)
		find     :conditions => ['(products.name like :search OR products.upc like :search) AND (entities.id=:current_location) AND (products.product_type_id=1)', {:search => "%#{search}%", :current_location => "#{User.current_user.location_id}"}],
			       :order => 'inventories.created_at DESC',
			       :joins => 'inner join products on products.id = inventories.product_id inner join entities on entities.id = inventories.entity_id'
	end
	def self.search_all_wo_pagination(search, page)
		find     :conditions => ['(products.name like :search OR products.upc like :search) AND (products.product_type_id=1)', {:search => "%#{search}%"}],
			       :order => 'inventories.created_at DESC',
			       :joins => 'inner join products on products.id = inventories.product_id inner join entities on entities.id = inventories.entity_id'
	end
end
