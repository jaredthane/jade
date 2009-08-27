# Jade Inventory Control System
#Copyright (C) 2009  Jared T. Martin

#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.

#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied account of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.

#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.


class SalesRepresentativesController < ApplicationController
	def index
		params[:from]=untranslate_month(params[:from]) if params[:from]
		params[:till]=untranslate_month(params[:till]) if params[:till]
		@from=(params[:from] ||Date.today)
  	@till=(params[:till] ||Date.today)
  	@site=User.current_user.location
		@reps=User.sales_reps_data(@from,@till,@site)
		respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @reps }
    end
  end

	def report
		params[:from]=untranslate_month(params[:from]) if params[:from]
		params[:till]=untranslate_month(params[:till]) if params[:till]
		@from=(params[:from] ||Date.today)
  	@till=(params[:till] ||Date.today)
  	@site=User.current_user.location
		@reps=User.sales_reps_data(@from,@till,@site)
		
		@data=[]
		@data << ['',{:text => 'Facturacion', :colspan => 3}, {:text => 'Valores', :colspan => 4}]
		@data << ['Asesor', 'Saldo Anterior', 'Facturas','Saldo Provisionado','Pagos','Saldo Cobrado','Facturas Pendientes','Saldo Final']
		total={:previous_balance=>0, :num_receipts=>0, :revenue=>0, :num_payments=>0, :cash_received=>0, :final_balance=>0, :facturas_pendientes=>0}
		x = Object.new.extend(ActionView::Helpers::NumberHelper)
		for rep in @reps
		  @data << [rep[:user].login, 
		  	rep[:num_receipts], 
		  	rep[:num_payments], 
		  	rep[:facturas_pendientes], 
		  	x.number_to_currency(rep[:previous_balance]), 
		  	x.number_to_currency(rep[:revenue]), 
		  	x.number_to_currency(rep[:cash_received]), 
		  	x.number_to_currency(rep[:final_balance])]
		  	
		  total[:previous_balance]+=rep[:previous_balance]
		  total[:num_receipts]+=rep[:num_receipts]
		  total[:revenue]+=rep[:revenue].to_i
		  total[:num_payments]+=rep[:num_payments]
		  total[:cash_received]+=rep[:cash_received]
		  total[:facturas_pendientes]+=rep[:facturas_pendientes]
		  total[:final_balance]+=rep[:final_balance]
		end
#		@data << ["---", "---", "---", "---", "---", "---", "---"]
		@data << ["Totales", x.number_to_currency(total[:previous_balance]), total[:num_receipts], x.number_to_currency(total[:revenue]), total[:num_payments], x.number_to_currency(total[:cash_received]), rep[:facturas_pendientes], x.number_to_currency(total[:final_balance])]
		prawnto :prawn => { :page_size => 'LETTER'}
		params[:format] = 'pdf'
		respond_to do |format|
		  format.pdf { render :layout => false }
		end
	end
end
