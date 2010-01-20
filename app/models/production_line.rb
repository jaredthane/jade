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

class ProductionLine < ProductionOrderLine
	
	##############################################################
	# Checks to make sure we have a valid quantity
	##############################################################
	def validate
		errors.add "","Cantidad no puede quedarse en blanco" if !quantity_planned or quantity_planned==''
	end	
	##############################################################
	# Returns cost of product * quantity
	##############################################################
	def unit_cost
		return production_order.cost  / (quantity||quantity_planned) / production_order.quantity
	end # def cost
	##############################################################
	# Returns cost of product * quantity
	##############################################################
	def total_cost
		return (production_order.cost ||0)
	end # def cost
	##############################################################
	# Creates movement to bring produced product into stock
	##############################################################
	def finish_movement(params={})
		params={:quantity => + self.quantity, 
		:serialized_product_id => self.serialized_product_id, 
		:created_at=>User.current_user.today, 
		:user_id => User.current_user.id, 
		:order_id => nil,
		:entity => self.production_order.site,
		:product_id => self.product_id,
		:movement_type_id => 14, 
		}.merge!(params)
		m=Movement.new(params)
		return m.save
	end # def finish_movement
end
