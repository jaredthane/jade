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
  	@reps=[]
  	for r in User.find(:all,
  											:conditions => ('users.location_id = ' + User.current_user.location.id.to_s),
  											:group => 'users.id',
  											:joins => 'inner join entities on entities.user_id=users.id')
  		@reps << r.sales_data(@from, @till)
  	end
		respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @reps }
      format.pdf {
        prawnto :prawn => { :page_size => 'LETTER'}
      }
    end
  end

#	def report
#		params[:from]=untranslate_month(params[:from]) if params[:from]
#		params[:till]=untranslate_month(params[:till]) if params[:till]
#		@from=(params[:from] ||Date.today)
#  	@till=(params[:till] ||Date.today)
#  	@site=User.current_user.location
#		@reps=User.sales_reps_data(@from,@till,@site)
#		@box=[]
#		@box << ['Asesor', 'Saldo']
#		for rep in @reps
#			@box<<[rep[:user].name, '']
#		end
#		@box<<['Total', '']
#		
#		prawnto :prawn => { :page_size => 'LETTER'}
#		params[:format] = 'pdf'
#		respond_to do |format|
#		  format.pdf { render :layout => false }
#		end
#	end
end
