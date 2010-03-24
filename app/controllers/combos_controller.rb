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
class CombosController < ApplicationController
  # GET /combos
  # GET /combos.xml
  
	before_filter :login_required
	
  def index
  	return false if !check_user(User::VIEW_COMBOS,'No tiene los derechos suficientes para ver los combos')
    #@combos = Product.find(:all)
		@combos = Product.search_for_combos(params[:search], params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @combos }
      format.js
    end
  end

  # GET /combos/1
  # GET /combos/1.xml
  def show
  	return false if !check_user(User::VIEW_COMBOS,'No tiene los derechos suficientes para ver los combos')
    @combo = Product.find(params[:id])

		if @combo.product_type_id==1
			redirect_to product_path(@combo)
			return false
		elsif @combo.product_type_id==2
			redirect_to discount_path(@combo)
			return false
		elsif @combo.product_type_id==4
			redirect_to service_path(@combo)
			return false
		end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @combo }
    end
  end

  # GET /combos/new
  # GET /combos/new.xml
  def new
  	return false if !check_user(User::CREATE_COMBOS,'No tiene los derechos suficientes para crear combos')
    @combo = Product.new
		@combo.relative_price=1
		@combo.static_price=0
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @combo }
    end
  end

  # GET /combos/1/edit
  def edit
  	return false if !check_user(User::CHANGE_COMBOS,'No tiene los derechos suficientes para cambiar combos')
    @combo = Product.find(params[:id])
  end

  # POST /combos
  # POST /combos.xml
  def create
  	return false if !check_user(User::CREATE_COMBOS,'No tiene los derechos suficientes para crear combos')
  	params[:product][:upc]=User.current_user.location.next_bar_code if params[:product][:upc]==""
    @combo = Product.new(params[:product])
    @combo.vendor_id=2
    @combo.create_related_values(params[:product][:default_cost], params[:product][:static_price], params[:product][:relative_price])
    respond_to do |format|
      if @combo.save
      	list= params['new_reqs'] || []
      	for l in list
      		new_req = Requirement.new(:product_id=>@combo.id)
      		new_req.update_attributes(l)
      		@combo.requirements << new_req
      	end
        flash[:notice] = 'Discuento ha sido creado exitosamente.'
        format.html { redirect_to(combos_url) }
        format.xml  { render :xml => @combo, :status => :created, :location => @combo }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @combo.errors, :status => :unprocessable_entity }
      end
      
    end
  end

  # PUT /combos/1
  # PUT /combos/1.xml
  
  def update
  	return false if !check_user(User::CHANGE_COMBOS,'No tiene los derechos suficientes para cambiar combos')
  	params[:product][:upc]=User.current_user.location.next_bar_code if params[:product][:upc]==""
		logger.info "==============running discioutns update====================="
		@combo = Product.find(params[:id])
		#Update existing reqs
    for l in @combo.requirements
			if params['existing_reqs']
				if params['existing_reqs'][l.id.to_s]
					logger.debug "UPDATING l=#{l.inspect}"
					l.attributes = params['existing_reqs'][l.id.to_s]
				else
					logger.debug "DELETING l=#{l.inspect}"
					@combo.requirements.delete(l)
				end
			else
				logger.debug "DELETING l=#{l.inspect}"
				@combo.requirements.delete(l)
			end
		end
		
		# Update New lines
		list= params['new_reqs'] || []
  	for l in list
  		logger.debug "ADDING l=#{l.inspect}"
  		new_req = Requirement.new(:product_id=>@combo.id)
  		new_req.update_attributes(l)
  		@combo.requirements.push( new_req)
  	end
  	# Update quantities available now that requirements have changed
  	for e in Entity.find_all_by_entity_type_id(3)
    	@combo.calculate_quantity(e.id)
    end
		if  @combo.update_attributes(params[:product])
			flash[:notice] = 'Discuento ha sido actualizado exitosamente.'
		end
	redirect_to(combo_path(@combo))

  end
  
  
  # DELETE /combos/1
  # DELETE /combos/1.xml
  def destroy
  	return false if !check_user(User::DELETE_COMBOS,'No tiene los derechos suficientes para borrar combos')
    @combo = Product.find(params[:id])
    @combo.destroy

    respond_to do |format|
      format.html { redirect_to(combos_url) }
      format.xml  { head :ok }
    end
  end
end
