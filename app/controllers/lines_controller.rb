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
class LinesController < ApplicationController
	skip_before_filter :verify_authenticity_token

	before_filter :login_required
	access_control [:new, :create, :update, :edit, :destroy] => '(Gerente | Admin | Ventas | Compras)' 

	def add_line(upc, quantity, order_type_id, relative_price = 1)
		@additional=Line.new(:created_at=>User.current_user.today, :order_type_id=>order_type_id)
		puts "order_type_id=" + order_type_id.to_s
#		@additional.order_type_id = order_type_id
		@additional.bar_code = upc
		puts "add price2" + @additional.price.to_s
		@additional.price = @additional.price * relative_price
#		if @additional.product
#			if @additional.product.product_type==3
#				## If its a combo, we don't want the price of the components included
#				## we will multiply this price by relative_price so that if this is part of a combo they get the discount
#				@additional.price = @additional.product.price(User.current_user.current_price_group, False) * relative_price
#			end
#		end
		puts "add price3" + @additional.price.to_s
		@additional.quantity = quantity
		return @additional
	end
	def add_product_or_combo(list, upc, quantity, order_type_id, relative_price=1)
		## Create a line for the product
		@newline = add_line(upc, quantity, order_type_id, relative_price)
		if @newline.product
			## If it doesnt need a serial number mark it received if the user wants
#			logger.debug "------------------------->order_type_id=#{order_type_id.to_s}"
			if order_type_id != '5'
				@newline.received=current_user.default_received if !@newline.product.serialized
			else
#				logger.debug "left null"
				@newline.received= nil
			end
			## Add the new line to the list of lines created
			list << @newline
			if @newline.product.product_type_id==3 ## If this is a combo, we have to add the components
	#			logger.debug "Adding a combo"
				## Update relative price so the children get the discount
				relative_price=(relative_price||0) * (@newline.product.relative_price||0)
				relative_price = 0                                 ###  <=============== This is for roberto. Must clean up later!!
				## Loop through each child product
				for comp in @newline.product.requirements
					## Add them recursively
					add_product_or_combo(list, comp.required.upc, comp.quantity, order_type_id, 0)
				end
			end
		end
	end
  # GET /lines/new
  # GET /lines/new.xml
  def new
  	
  	@order_type_id = params[:order_type_id] || 0
    if @order_type_id == 1
    	@client=Entity.find_by_name(params[:client_name])
    	if @client
	    	current_user.price_group_name_id = @client.price_group_name_id
	    end
    end
		@lines=[]
		add_product_or_combo(@lines, params[:bar_code], 1, @order_type_id)
		puts "params[:format]=#{params[:format].to_s}"
		if @lines.length == 0
			puts "Rendering Error"
		 	render :action => 'error'
		else
			respond_to do |wants|
		    wants.js
		  end
		end
  end

	def make_shadow
		@order_id = params[:order_id]
		@product_id = Product.find_by_upc(params[:bar_code])
    respond_to do |wants|
      wants.html do
        redirect_to '/orders/' + @line.order_id.to_s + '/edit'
      end
      wants.js
    end
	end

#  # POST /lines
#  # POST /lines.xml
#  def create
#   	@line = Line.create(params[:line])
#   	new_line.set_serial_number_with_product(params[:line][:serial_number], params[:line][:product_name])
#    respond_to do |wants|
#      wants.html do
#        redirect_to '/orders/' + @line.order_id.to_s + '/edit'
#      end
#      wants.js
#    end
#  end

#  # PUT /lines/1
#  # PUT /lines/1.xml
#  def update
#    @line = Line.find(params[:id])
#   	new_line.set_serial_number_with_product(params[:line][:serial_number], params[:line][:product_name])

#    respond_to do |format|
#      if @line.update_attributes(params[:line])
#        flash[:notice] = 'Line was successfully updated.'
#        format.html { redirect_to(@line) }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @line.errors, :status => :unprocessable_entity }
#      end
#    end
#  end

  # DELETE /lines/1
  # DELETE /lines/1.xml
#  def destroy
#    @line = Line.find(params[:id])
#    @line.destroy

#    respond_to do |format|
#      format.html { redirect_to(lines_url) }
#      format.xml  { head :ok }
#    end
#  end
end
