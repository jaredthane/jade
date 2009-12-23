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


class PhysicalCountsController < ApplicationController
	before_filter :login_required
	def index
  	if !current_user.has_rights(['Admin','Gerente','Inventario'])
			redirect_back_or_default('/physical_counts')
			flash[:error] = "No tiene los derechos suficientes para ver cuentas fisicas"
  	end
		@counts = Order.search_physical_counts(params[:search], params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @count }
    end
  end
  def show
  	if !current_user.has_rights(['Admin','Gerente','Inventario'])
			redirect_back_or_default('/physical_counts')
			flash[:error] = "No tiene los derechos suficientes para ver cuentas fisicas"
  	end
    @count = Order.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @count }
    end
  end
  def new
  	if !current_user.has_rights(['Admin','Gerente','Inventario'])
			redirect_back_or_default('/physical_counts')
			flash[:error] = "No tiene los derechos suficientes para crear cuentas fisicas"
  	end
    @count = Order.new(:order_type_id => 5, :created_at=>User.current_user.today)
    @count.user = current_user
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @count }
    end
  end
  def edit
  	if !current_user.has_rights(['Admin','Gerente','Inventario'])
			redirect_back_or_default('/physical_counts')
			flash[:error] = "No tiene los derechos suficientes para cambiar cuentas fisicas"
  	end
   	@count = Order.find(params[:id])
  end
  def post
    if !current_user.has_rights(['Admin','Gerente','Inventario'])
      redirect_back_or_default('/physical_counts')
      flash[:error] = "No tiene los derechos suficientes para cambiar cuentas fisicas"
    end
    @count = Order.find(params[:id])
    errors=false
    lines_to_delete=[]
    #Update existing lines
    for l in @count.lines
      logger.debug "l.id=" + l.id.to_s
      if params['existing_lines']
        logger.debug "params['existing_lines'][l.id.to_s]=" + params['existing_lines'][l.id.to_s].to_s
      end
      if params['existing_lines']
        if params['existing_lines'][l.id.to_s]
          logger.debug "setting attribs for line #{l.id}"
          logger.debug "l.warranty before=#{l.warranty.to_s}"
          l.attributes = params['existing_lines'][l.id.to_s]
          logger.debug "l.warranty afterz=#{l.warranty.to_s}"
        else
          logger.debug "deleting line #{l.id}"
          lines_to_delete << l
        end
      else
        logger.debug "deleting line #{l.id}"
        lines_to_delete << l
      end
    end
    for l in lines_to_delete
      @count.lines.delete(l)
    end
    # Update New lines
    list= params['new_lines'] || []
    for l in list
      new_line = Line.new(:order_id=>@count.id,:created_at=>User.current_user.today)
      new_line.product_id = l[:product_id]    
      new_line.quantity = l[:quantity]
      new_line.attributes=l  
      logger.debug "about to push #{new_line.inspect}"    
      @count.lines.push(new_line)
    end
    errors = true if !@count.post
    if !errors
      flash[:notice] = 'Cuenta Fisica ha sido procesado exitosamente.'
      redirect_to(physical_count_url(@count))
    else
      format.html { render :action => "edit" }
    end
  end
  def create
		@count = Order.new(:order_type_id => 5, :created_at=>User.current_user.today)
		@count.attributes = params["count"]
		if !current_user.has_rights(['Admin','Gerente','Inventario'])
			redirect_back_or_default('/physical_counts')
			flash[:error] = "No tiene los derechos suficientes para crear cuentas fisicas"
		end
  	errors=false
  	list= params['new_lines'] || []
  	for l in list
  		new_line = Line.new(:order=>@count, :created_at=>User.current_user.today)
  		#new_line.product_name = l[:product_name]  	
  		new_line.product_id = l[:product_id]  	
			new_line.quantity = l[:quantity]  
			#new_line.set_serial_number_with_product(l[:serial_number], l[:product_name])
  		#logger.debug "product id:   ->" + l[:product_name]
  		errors = true if !new_line.update_attributes(l)
  		@count.lines << new_line
  	end
	  if params[:submit_type] == 'post' and !errors
	  	errors = true if !@count.post
	  end
	  errors = true if !@count.save
		respond_to do |format|
			if !errors
        flash[:notice] = 'Cuenta Fisica ha sido creado exitosamente.'
        format.html {  redirect_to(@count)  }
        format.xml  { render :xml => @count, :status => :created }
      else
		    @count.errors.each do |error|
					logger.debug "error[0]=#{error[0].to_s}"
					if error[0] == "lines"
						errors.delete(error)
					end
				end
        format.html { render :action => "new" }
        format.xml  { render :xml => @count.errors, :status => :unprocessable_entity }
      end
    end
  end
  def update
  	@count = Order.find(params[:id])
  	if !current_user.has_rights(['Admin','Gerente','Inventario'])
			redirect_back_or_default('/physical_counts')
			flash[:error] = "No tiene los derechos suficientes para cambiar cuentas fisicas"
  	end
  	errors=false
    lines_to_delete=[]
    #Update existing lines
    for l in @count.lines
			logger.debug "l.id=" + l.id.to_s
			if params['existing_lines']
				logger.debug "params['existing_lines'][l.id.to_s]=" + params['existing_lines'][l.id.to_s].to_s
			end
			if params['existing_lines']
				if params['existing_lines'][l.id.to_s]
					logger.debug "setting attribs for line #{l.id}"
					logger.debug "l.warranty before=#{l.warranty.to_s}"
					l.attributes = params['existing_lines'][l.id.to_s]
					logger.debug "l.warranty afterz=#{l.warranty.to_s}"
				else
					logger.debug "deleting line #{l.id}"
					lines_to_delete << l
				end
			else
				logger.debug "deleting line #{l.id}"
				lines_to_delete << l
			end
		end
		for l in lines_to_delete
			@count.lines.delete(l)
		end
		# Update New lines
		list= params['new_lines'] || []
  	for l in list
  		new_line = Line.new(:order_id=>@count.id, :created_at=>User.current_user.today)
  		new_line.product_id = l[:product_id]		
  		new_line.quantity = l[:quantity]
  		new_line.attributes=l  
  		logger.debug "about to push #{new_line.inspect}"  	
  		@count.lines.push(new_line)
  	end
  	if params['submit_type'] == 'post' and !errors
	  	errors = true if !@count.post
	  end
  	errors = true if !@count.update_attributes(params[:count])
  	
  	respond_to do |format|
      if !errors
        flash[:notice] = 'Cuenta Fisica ha sido actualizado exitosamente.'
        format.html { redirect_to(@count) }
        format.xml  { head :ok }
      else
      	logger.debug "saving order didnt work"
        format.html { render :action => "edit" }
        format.xml  { render :xml => @count.errors, :status => :unprocessable_entity }
      end
    end
  end
  def destroy
  	if !current_user.has_rights(['Admin','Gerente','Inventario'])
			redirect_back_or_default('/physical_counts')
			flash[:error] = "No tiene los derechos suficientes para cambiar cuentas fisicas"
  	end
    @count = Order.find(params[:id])
    @count.destroy
    respond_to do |format|
      format.html { redirect_to(physical_counts_url) }
      format.xml  { head :ok }
    end
  end
  def submit
  	if !current_user.has_rights(['Admin','Gerente','Inventario'])
			redirect_back_or_default('/physical_counts')
			flash[:error] = "No tiene los derechos suficientes para cambiar cuentas fisicas"
  	end
    @count = Order.find(params[:id])

    respond_to do |format|
      if @count.update_attributes(params[:count])
        flash[:notice] = 'Pago ha sido actualizado exitosamente.'
        format.html { redirect_to(@count.order) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @count.errors, :status => :unprocessable_entity }
      end
    end
  end
end
