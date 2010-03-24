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


class EntriesController < ApplicationController
	def index
		return false if !check_user(User::VIEW_ACCOUNTS,'No tiene los derechos suficientes para ver las cuentas')
	  @from=(untranslate_month(params[:from])||Date.today)
    @till=(untranslate_month(params[:till])||Date.today)
		@account = Account.find(params[:filter])
		if params[:pdf]=='1'
      @entries = Entry.search(params[:filter], @from, @till)
      params[:format] = 'pdf'
    else
      @entries = Entry.search(params[:filter], @from, @till, (params[:page]||1))
    end
		respond_to do |format|
		  format.html # index.html.erb
		  format.pdf {
		    prawnto :prawn => {:skip_page_creation=>true}
		  }
		end
	end
end
