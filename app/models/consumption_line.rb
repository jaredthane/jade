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

class ConsumptionLine < ProductionOrderLine
	##############################################################
	# Returns cost of product * quantity
	##############################################################
	def cost
		return product.cost * quantity
	end # def cost
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
		:entity => self.production_order.site,
		:product_id => self.product_id,
		:movement_type_id => 13, 
		}.merge!(params)
		m=Movement.new(params)
		return m.save
	end # def start_movement
end
