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
class InventoriesController < ApplicationController
  # GET /inventories
  # GET /inventories.xml
  def index
		@inventories = Inventory.search(params[:search], params[:page])
		@search=params[:search] || ""
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @inventories }
    end
  end

  # PUT /inventories/1
  # PUT /inventories/1.xml
  def update
  	@search=params[:search] || ""
  	params[:inventories].each do |attributes|
			#puts "attribs: " + attributes.to_s
			#puts "attribs[1]: " + attributes[1].to_s
			@inventory = Inventory.find(attributes[0])
			#puts "id:" + attributes[1][:id]
			@inventory.to_order = attributes[1][:to_order]
			@inventory.max = attributes[1][:max]
			@inventory.min = attributes[1][:min]
			@inventory.save
		end
		redirect_to('/inventories?search=' + @search)
  end
  
  def clear
		@inventories = Inventory.search_wo_pagination(params[:search])
		@search = params[:search] || ""
		for i in @inventories
			i.product.to_order = 0
		end
		redirect_to('/inventories?search=' + @search)
	end
	def recommend
		@inventories = Inventory.search_wo_pagination(params[:search])
		@search = params[:search] || ""
		for i in @inventories
			logger.debug "i=#{i.inspect}"
			logger.debug "i.quantity + i.on_order=#{(i.quantity + i.on_order).to_s}"
			logger.debug "(i.min || 0) + i.sales_waiting=#{((i.min || 0) + i.sales_waiting).to_s}"
			if i.quantity + i.on_order < (i.min || 0) + i.sales_waiting
				logger.debug "here"
				if i.quantity + i.on_order + (i.max||0) > (i.min || 0) + i.sales_waiting
					i.product.to_order = (i.max||0)
					logger.debug "i.product.to_order=#{i.product.to_order.to_s}"
					#puts "i.quantity=#{i.quantity.to_s}"
				else
					i.product.to_order = i.sales_waiting + (i.min || 0) - i.on_order - i.quantity
					logger.debug "i.product.to_order=#{i.product.to_order.to_s}"
				end
			end
		end
		redirect_to('/inventories?search=' + @search)
	end
end
