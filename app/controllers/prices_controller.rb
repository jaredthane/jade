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
  # GET /prices
  # GET /prices.xml
  def index
		@prices = Price.search(params[:search], params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @prices }
    end
  end
   
  # PUT /prices/1
  # PUT /prices/1.xml
  def update
    params[:prices].each do |attributes|
			@price = Price.find(attributes[0])
			@price.fixed = attributes[1][:fixed]
			@price.relative = attributes[1][:relative]
			logger.debug "About to set available <============================================="
			@price.available_str = attributes[1][:available_str]
			logger.debug "@price.available_str=#{@price.available_str.to_s}"
			@price.save
			@price = Price.find(attributes[0])
			logger.debug "@price.available_str=#{@price.available_str.to_s}"
			logger.debug "@price.available=#{@price.available.to_s}"
		end
		redirect_to('/prices')
  end
end
