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
	before_filter :login_required
	access_control [:new, :create, :update, :edit, :destroy] => '(gerente | admin | ventas | compras)' 
  # GET /lines
  # GET /lines.xml
  def index
		redirect_to(orders_path)
  end

  # GET /lines/1
  # GET /lines/1.xml
  def show
    @line = Line.find(params[:id])

    redirect_to(orders_path(@line.order))
  end
	def add_line(upc, quantity, order_type, price = nil)
		@additional=Line.new()
		@additional.order_type = order_type
		@additional.bar_code = upc
		if price
			@additional.price = price
		end
		@additional.quantity = quantity
		return @additional
	end
	def add_product_or_combo(list, upc, quantity, order_type, price=nil)
		@newline = add_line(upc, quantity, order_type, price)
		@newline.received=current_user.default_received if !@newline.product.serialized
		
		list << @newline
		if @newline.product.product_type_id==3 # If this is a combo, we have to add the components
			logger.debug "Adding a combo"
			for comp in @newline.product.requirements
				newprice =  (comp.product.price||0) * (comp.relative_price||0) + (comp.static_price||0)
				add_product_or_combo(list, comp.required.upc, comp.quantity, order_type, newprice)
			end
		end
	end
  # GET /lines/new
  # GET /lines/new.xml
  def new
 		puts 'creating new line'
#  	puts params[:line][:order_type]
#  	puts params[:line][:client_name]
  	
    if params[:line][:order_type]=='sales'
    	@client=Entity.find_by_name(params[:line][:client_name])
    	if @client
	    	current_user.price_group_name_id = @client.price_group_name_id
	    end
    end
    
		@lines=[]
		add_product_or_combo(@lines, params[:line][:bar_code], 1, params[:line][:order_type])
		logger.debug "default received =" + current_user.default_received.to_s
	  respond_to do |wants|
	    wants.html do
	      redirect_to '/orders/' + @line.order_id.to_s + '/edit'
	    end
	    wants.js
	  end
  end

  # GET /lines/1/edit
  def edit
    @line = Line.find(params[:id])
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

  # POST /lines
  # POST /lines.xml
  def create
   	@line = Line.create(params[:line])
   	new_line.set_serial_number_with_product(params[:line][:serial_number], params[:line][:product_name])
    respond_to do |wants|
      wants.html do
        redirect_to '/orders/' + @line.order_id.to_s + '/edit'
      end
      wants.js
    end
  end

  # PUT /lines/1
  # PUT /lines/1.xml
  def update
    @line = Line.find(params[:id])
   	new_line.set_serial_number_with_product(params[:line][:serial_number], params[:line][:product_name])

    respond_to do |format|
      if @line.update_attributes(params[:line])
        flash[:notice] = 'Line was successfully updated.'
        format.html { redirect_to(@line) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @line.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /lines/1
  # DELETE /lines/1.xml
  def destroy
    @line = Line.find(params[:id])
    @line.destroy

    respond_to do |format|
      format.html { redirect_to(lines_url) }
      format.xml  { head :ok }
    end
  end
end
