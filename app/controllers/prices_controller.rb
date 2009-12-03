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
	
class PricesController < ApplicationController
	before_filter :login_required
	access_control [:new, :show, :index, :create, :update, :edit] => '(Gerente | Admin)' 
	access_control [:destroy] => '(Admin)'
  # GET /prices
  # GET /prices.xml
  def index
		@prices = Price.search(params[:search], params[:page])
		@search=params[:search]
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @prices }
    end
  end
   
  # PUT /prices/1
  # PUT /prices/1.xml
  def change_scope
    logger.debug "current_user.price_group_name_id=" + current_user.price_group_name_id.to_s
    logger.debug "current_user.location_id=" + current_user.location_id.to_s
    current_user.price_group_name_id = params[:user][:price_group_name_id].to_i if params[:user][:price_group_name_id]
#    logger.debug "setting price group name ="+ params[:user][:price_group_name_id]
    current_user.location_id = params[:user][:location_id].to_i if params[:user][:location_id]
#    logger.debug "setting location ="+ params[:location_id]
    current_user.save()
    logger.debug "current_user.price_group_name_id=" + current_user.price_group_name_id.to_s
    logger.debug "current_user.location_id=" + current_user.location_id.to_s
	redirect_to('/prices?search='+(params[:search]||''))
  end
  def update
    sucess=true
    params[:prices].each do |attributes|
			@price = Price.find(attributes[0])
			@price.fixed = attributes[1][:fixed]
			@price.relative = attributes[1][:relative]
			logger.debug "About to set available <============================================="
#			@price.available_str = attributes[1][:available_str]
			if !attributes[1][:available]
				@price.available=false
			else
				@price.available=true
			end
			logger.debug "@price.available_str=#{@price.available_str.to_s}"
			success=false if !@price.save
			@price = Price.find(attributes[0])
			logger.debug "@price.available_str=#{@price.available_str.to_s}"
			logger.debug "@price.available=#{@price.available.to_s}"
		end
		if sucess
		    flash[:notice] = 'Precios han sido actualizado exitosamente.'
		else
		    flash[:notice] = 'Alugnos precios no se puedieron guardar.'
		end
		if params[:prices].length == 1
		    logger.debug params[:prices].keys[0]
		    @price = Price.find(params[:prices].keys[0].to_i)
		    redirect_to(@price.product)
		    return false
		end
		redirect_to('/prices')
  end
end
