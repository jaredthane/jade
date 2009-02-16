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
