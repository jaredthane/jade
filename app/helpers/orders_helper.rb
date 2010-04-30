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
	def currency_to_text(num, add_end=true)
        msg= ''
        if num > 1000
            msg= (num >= 2000 ? self.currency_to_text((num/1000).to_i,false) + ' mil ' + (self.currency_to_text(num % 1000,false)||'') : 'mil ' + (self.currency_to_text(num % 1000,false)||'')).strip
        elsif num == 1000
            msg='mil'
        elsif num == 100
            msg= 'cien'
        elsif num > 100
            case (num/100).to_i*100
            when 100
                msg= ('ciento ' + currency_to_text((num % 100).to_i,false)).strip
            when 200
                msg= ('doscientos ' + currency_to_text((num % 100).to_i,false)).strip
            when 300
                msg= ('trescientos ' + currency_to_text((num % 100).to_i,false)).strip
            when 400
                msg= ('cuatrocientos ' + currency_to_text((num % 100).to_i,false)).strip
            when 500
                msg= ('quinientos ' + currency_to_text((num % 100).to_i,false)).strip
            when 600
                msg= ('seiscientos ' + currency_to_text((num % 100).to_i,false)).strip
            when 700
                msg= ('setecientos ' + currency_to_text((num % 100).to_i,false)).strip
            when 800
                msg= ('ochocientos ' + currency_to_text((num % 100).to_i,false)).strip
            when 900
                msg= ('novecientos ' + currency_to_text((num % 100).to_i,false)).strip
            end
        elsif num >= 30
            msg= 'cien' if num == 100
            case (num/10).to_i*10
            when 30
                msg= num % 10>0 ? 'treinta y ' + (currency_to_text((num % 10).to_i,false)).strip : 'treinta'
            when 40
                msg= num % 10>0 ?  'cuarenta y ' + (currency_to_text((num % 10).to_i,false)).strip : 'cuarenta'
            when 50
                msg= num % 10>0 ?  'cincuenta y ' + (currency_to_text((num % 10).to_i,false)).strip : 'cincuenta'
            when 60
                msg= num % 10>0 ?  'sesenta y ' + (currency_to_text((num % 10).to_i,false)).strip : 'sesenta'
            when 70
                msg= num % 10>0 ?  'setenta y ' + (currency_to_text((num % 10).to_i,false)).strip : 'setenta'
            when 80
                msg= num % 10>0 ?  'ochenta y ' + (currency_to_text((num % 10).to_i,false)).strip : 'ochenta'
            when 90
                msg= num % 10>0 ?  'noventa y ' + (currency_to_text((num % 10).to_i,false)).strip : 'noventa'
            end
        elsif num > 19
            case num
            when 20
                msg= "veinte"
            when 21
                msg= "veintiun"
            when 22
                msg= "veintidós"
            when 23
                msg= "veintitrés"
            when 24
                msg= "veinticuatro"
            when 25
                msg= "veinticinco"
            when 26
                msg= "veintiséis"
            when 27
                msg= "veintisiete"
            when 28
                msg= "veintiocho"
            when 29
                msg= "veintinueve"
            end
        elsif num >= 1
            case num.to_i
            when 1
                msg= 'un'
            when 2
                msg= 'dos'
            when 3
                msg= 'tres'
            when 4
                msg= 'cuatro'
            when 5
                msg= 'cinco'
            when 6
                msg= 'seis'
            when 7
                msg= 'siete'
            when 8
                msg= 'ocho'
            when 9
                msg= 'nueve'
            when 10
                msg= 'diez'
            when 11
                msg= 'once'
            when 12
                msg= 'doce'
            when 13
                msg= 'trece'
            when 14
                msg= 'catorce'
            when 15
                msg= 'quince'
            when 16
                msg= 'dieciséis'
            when 17
                msg= 'diecisiete'
            when 18
                msg= 'dieciocho'
            when 19
                msg= 'diecinueve'
            end
        end 
        if add_end
            if msg.length>=2
                if msg[-2..-1]=='un'
                    msg += ' dolar'
                else
                    msg += ' dolares' 
                end
            end
            if num % 1 != 0 and msg != ''
                return msg + ' con ' + currency_to_text(num % 1 * 100,false) + ' centavos'
            elsif msg == ''
                return currency_to_text(num % 1 * 100,false) + ' centavos'
            end
        else
            return msg
        end
        return msg
    end
end
