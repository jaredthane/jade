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
			if order.order_type_id==Order::COUNT
				return "En Proceso"
			else
				return "Esperando Entrega"
			end
		else
			if order.amount_paid == order.grand_total or order.order_type_id==5
				return "Terminado"
			else
				return "Esperando Pago" 
			end
		end
	end
	def last_action(order)
		if order.last_received == nil
			if order.order_type_id==Order::COUNT
				return "Creado: " + order.created_at.to_date.to_s
			else
				return "Solicitado: " + order.created_at.to_date.to_s
			end
		else
			if order.order_type_id==Order::COUNT				
				return "Procesado: " + order.last_received.to_date.to_s
			else
				return "Entregado: " + order.last_received.to_date.to_s
			end
		end
	end
	def currency_to_text(num, prefixed=true)
	    if num > 1000
	    elsif num > 100
	    elsif num > 20
	    elsif num < 1
	    elsif num == 1
            return 'un'
	    elsif num == 2
            return 'dos'
	    elsif num == 3
            return 'tres'
	    elsif num == 4
            return 'cuatro'
	    elsif num == 5
            return 'cinco'
	    elsif num == 6
            return 'seis'
	    elsif num == 7
            return 'siete'
	    elsif num == 8
            return 'ocho'
	    elsif num == 9
            return 'nueve'
	    elsif num == 10
            return 'diez'
	    elsif num == 11
            return 'once'
	    elsif num == 12
            return 'doce'
	    elsif num == 13
            return 'trece'
	    elsif num == 14
            return 'catorce'
	    elsif num == 15
            return 'quince'
	    elsif num == 16
            return 'dieziséis'
	    elsif num == 17
            return 'diecisiete'
	    elsif num == 18
            return 'dieciocho'
	    elsif num == 19
            return 'diecinueve'
	    elsif num == 20
            return prefixed ?'veinte':'veinti'
	    elsif num == 30
            return 'treinta'
	    elsif num == 40
            return 'cuarenta'
	    elsif num == 50
            return 'cincuenta'
	    elsif num == 60
            return 'sesenta'
	    elsif num == 70
            return 'setenta'
	    elsif num == 80
            return 'ochenta'
	    elsif num == 90
            return 'noventa'
	    elsif num == 100
            return 'cien'
        end
	end
end
