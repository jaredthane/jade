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

class AuditLogger < Logger
	def format_message(severity, timestamp, progname, msg)
	  "#{timestamp.to_formatted_s(:db)} #{severity} #{msg}\n" 
	end 
end 
	
class ApplicationController < ActionController::Base
# Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  before_filter { |c| User.current_user = c.current_user }

  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'e90656bc2104adcadb40b5ce07b91b4a'
  logfile = File.open('log/audit.log', 'a')   
  logfile.sync = true  #remove this for production 
	audit = AuditLogger.new(logfile) 
#	def untranslate_month(date)
#		parts=date.split
#		case parts[0]
#		when 'Enero'
#			parts[0]='January'
#		when 'Febrero'
#			parts[0]='February'
#		when 'Marzo'
#			parts[0]='March'
#		when 'Abril'
#			parts[0]='April'
#		when 'Mayo'
#			parts[0]='May'
#		when 'Junio'
#			parts[0]='June'
#		when 'Julio'
#			parts[0]='July'
#		when 'Agosto'
#			parts[0]='August'
#		when 'Septiembre'
#			parts[0]='September'
#		when 'Octubre'
#			parts[0]='October'
#		when 'Noviembre'
#			parts[0]='November'
#		when 'Deciembre'
#			parts[0]='December'
#		end
#		return parts.join(' ')
#	end


  def generate_receipt(order)
  	order.receipt_filename = "#{RAILS_ROOT}/invoice_pdfs/{order.id}.pdf"
  	@order=order
  	prawnto :prawn => {:skip_page_creation=>true}
	  pdf_string = render_to_string :template => 'orders/receipt.pdf.prawn', :layout => false
		File.open(order.receipt_filename, 'w') { |f| f.write(pdf_string) }
		User.current_user.location.next_receipt_number=order.receipt_number.to_i+1
  	User.current_user.location.save
	end
	def check_user(right_id, msg)
		logger.debug "current_user.has_right(right_id)=#{current_user.has_right(right_id).to_s}"
		r=current_user.has_right(right_id)
		if !r
			redirect_back_or_default('/products')
			flash[:error] = msg
			return false
		else
			return r
		end
	end
	def untranslate_month(date)
	  if date
	    if date.class==String
	      if date.include? "-"
	        return DateTime.strptime(date, '%Y-%m-%d %H:%M:%S')
	      elsif date.include? ":"
	        return DateTime.strptime(date, '%d/%m/%Y %H:%M:%S')
	      else
	        if date!=''
        		return Date.strptime(date, '%d/%m/%Y')
        	else 
        	  return nil
        	end
        end
      elsif date.class==Date
        return date
      end
    else
      return nil	
    end
	end
end
