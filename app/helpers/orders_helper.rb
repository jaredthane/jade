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

module OrdersHelper
	def fields_for_line(line, &block)
		prefix = line.new_record? ? 'new' : 'existing'
		fields_for("lines[#{prefix}][]", line, &block)
	end

	def add_line_link(name) 
		link_to_function name do |page| 
		  page.insert_html :bottom, :lines, :partial => 'line', :object => Line.new 
		end 
	end 
	def awaiting(order)
		if order.last_received == nil
			return "Entrega"
		else
			if order.amount_paid == order.total_price_with_tax
				return "Terminado"
			else
				return "Pago" 
			end
		end
	end
	def last_action(order)
		if order.last_received == nil
			return "Solicitado: " + order.created_at.to_date.to_s
		else
			return "Entregado: " + order.last_received.to_date.to_s
		end
	end
	
end
