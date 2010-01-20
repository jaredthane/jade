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

class ProductionOrderLine < ActiveRecord::Base
  belongs_to :production_order
  belongs_to :product
  belongs_to :serialized_product
	def validate
		errors.add "","Cantidad no puede quedarse en blanco" if !quantity or quantity==''
	end
	##############################################################
	# Requires: entity_id, product_id, quantity, movement_type_id, order_id
	# Accepts all other attributes of Movement
	##############################################################
	def start_movement(params={})
		params={:quantity => - self.quantity, 
		:serialized_product_id => self.serialized_product_id, 
		:created_at=>User.current_user.today, 
		:user_id => User.current_user.id, 
		:order_id => nil,
		:entity_id => self.production_order.site_id,
		:product_id => self.product_id,
		:movement_type_id => 13, 
		}.merge!(params)
		return Movement.create(params)
	end # def start_movement
	
	##############################################################
	#
	##############################################################
	def finish_movement
		params={:quantity => + self.quantity, 
		:serialized_product_id => self.serialized_product_id, 
		:created_at=>User.current_user.today, 
		:user_id => User.current_user.id, 
		:order_id => nil,
		:entity_id => self.production_order.site_id,
		:product_id => self.product_id,
		:movement_type_id => 14, 
		}.merge!(params)
		return Movement.create(params)
	end # def finish_movement
end
