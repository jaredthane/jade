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
			if order.amount_paid == order.total_price
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
