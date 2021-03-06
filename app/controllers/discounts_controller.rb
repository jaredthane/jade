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
class DiscountsController < ApplicationController
  # GET /discounts
  # GET /discounts.xml
  
	before_filter :login_required
	access_control [:new, :create, :update, :edit, :destroy] => '(Gerente | Admin)' 
  def index
  	return false if !check_user(User::VIEW_DISCOUNTS,'No tiene los derechos suficientes para ver los descuentos')
    #@discounts = Product.find(:all)
		@discounts = Product.search_for_discounts(params[:search], params[:page])
		if @discounts.length == 1
			@discount=@discounts[0]
			render :action => 'show'
			return false
				#redirect_to('/products/' + @products[0].to_s)
		end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @discounts }
      format.js
    end
  end

  # GET /discounts/1
  # GET /discounts/1.xml
  def show
  	return false if !check_user(User::VIEW_DISCOUNTS,'No tiene los derechos suficientes para ver los descuentos')
    @discount = Product.find(params[:id])
		if @discount.product_type_id==1
			redirect_to product_path(@discount)
			return false
		elsif @discount.product_type_id==3
			redirect_to combo_path(@discount)
			return false
		elsif @discount.product_type_id==4
			redirect_to service_path(@discount)
			return false
		end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @discount }
    end
  end

  # GET /discounts/new
  # GET /discounts/new.xml
  def new
  	return false if !check_user(User::CREATE_DISCOUNTS,'No tiene los derechos suficientes para crear los descuentos')
    @discount = Product.new(:relative_price=>1,:static_price=>0)
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @discount }
    end
  end

  # GET /discounts/1/edit
  def edit
  	return false if !check_user(User::CHANGE_DISCOUNTS,'No tiene los derechos suficientes para cambiar los descuentos')
    @discount = Product.find(params[:id])
  end

  # POST /discounts
  # POST /discounts.xml
  def create
  	return false if !check_user(User::CREATE_DISCOUNTS,'No tiene los derechos suficientes para crear los descuentos')
  	params[:product][:upc]=User.current_user.location.next_bar_code if params[:product][:upc]==""
    @discount = Product.new(params[:product])
    @discount.create_related_values(params[:product][:default_cost], params[:product][:static_price], params[:product][:relative_price])
    respond_to do |format|
      if @discount.save
      	list= params['new_reqs'] || []
      	for l in list
      		new_req = Requirement.new(:product_id=>@discount.id)
      		new_req.update_attributes(l)
      		@discount.requirements << new_req
      	end
        flash[:notice] = 'Discuento ha sido creado exitosamente.'
        format.html { redirect_to(discounts_url) }
        format.xml  { render :xml => @discount, :status => :created, :location => @discount }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @discount.errors, :status => :unprocessable_entity }
      end
      
    end
  end

  # PUT /discounts/1
  # PUT /discounts/1.xml
  
  def update
  	return false if !check_user(User::CHANGE_DISCOUNTS,'No tiene los derechos suficientes para cambiar los descuentos')
  	params[:product][:upc]=User.current_user.location.next_bar_code if params[:product][:upc]==""
		logger.info "==============running discioutns update====================="
		@discount = Product.find(params[:id])
		#Update existing reqs
    for l in @discount.requirements
			if params['existing_reqs']
				if params['existing_reqs'][l.id.to_s]
					logger.debug "UPDATING l=#{l.inspect}"
					l.attributes = params['existing_reqs'][l.id.to_s]
				else
					logger.debug "DELETING l=#{l.inspect}"
					@discount.requirements.delete(l)
				end
			else
				logger.debug "DELETING l=#{l.inspect}"
				@discount.requirements.delete(l)
			end
		end
		
		# Update New lines
		list= params['new_reqs'] || []
  	for l in list
  		logger.debug "ADDING l=#{l.inspect}"
  		new_req = Requirement.new(:product_id=>@discount.id)
  		new_req.update_attributes(l)
  		@discount.requirements.push( new_req)
  	end
		if  @discount.update_attributes(params[:product])
			flash[:notice] = 'Discuento ha sido actualizado exitosamente.'
		end
	redirect_to(discount_path(@discount))

  end
  
  
  # DELETE /discounts/1
  # DELETE /discounts/1.xml
  def destroy
  	return false if !check_user(User::DELETE_DISCOUNTS,'No tiene los derechos suficientes para borrar los descuentos')
    @discount = Product.find(params[:id])
    @discount.destroy

    respond_to do |format|
      format.html { redirect_to(discounts_url) }
      format.xml  { head :ok }
    end
  end
end
