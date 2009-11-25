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

class OrdersController < ApplicationController
	before_filter :login_required
	access_control [:create_batch, :create_orders, :show_batch, :new_purchase] => '(Gerente | Admin | Compras)' 
	access_control [:new_sale] => '(Gerente | Admin | Ventas)'
	access_control [:destroy] => '(Admin)'
	def allowed(order_type_id, action)
		case (order_type_id)
		  when 1
		  	if action=="edit"
					if !current_user.has_rights(['Admin','Gerente','Ventas'])
						redirect_back_or_default('/products')
						flash[:error] = "No tiene los derechos suficientes para cambiar las Ventas"
						return false
					end
				elsif action=="view"
					if !current_user.has_rights(['Admin','Gerente','Ventas','Compras','inventario'])
						redirect_back_or_default('/products')
						flash[:error] = "No tiene los derechos suficientes para ver las Ventas"
						return false
					end
				end
		  when 2
		  	if !current_user.has_rights(['Admin','Compras','Gerente','inventario'])
					redirect_back_or_default('/products')
					flash[:error] = "No tiene los derechos suficientes para ver las Compras"
						return false
		  	end
		  when 3
		  	if action=="edit"
					if !current_user.has_rights(['Admin','Gerente','Ventas','inventario'])
						redirect_back_or_default('/products')
						flash[:error] = "No tiene los derechos suficientes para cambiar el uso interno"
						return false
					end
				elsif action=="view"
					if !current_user.has_rights(['Admin','Gerente','Ventas','Compras','inventario'])
						redirect_back_or_default('/products')
						flash[:error] = "No tiene los derechos suficientes para ver el uso interno"
						return false
					end
				end
    end  
    return true  
	end
	
  # GET /orders
  # GET /orders.xml
  def index
		@order_type_id = params[:order_type_id] || 0
		case @order_type_id
		when 0
				@orders = Order.search_by_rights(params[:search], params[:page])
		when 1
			@orders = Order.search_sales(params[:search], params[:page])
		when 2
			@orders = Order.search_purchases(params[:search], params[:page])
		when 3
			@orders = Order.search_internal(params[:search], params[:page])
		end
		if @orders.length == 1
			@order=@orders[0]
			return false if !allowed(@order.order_type_id, 'view')
			logger.debug "orderis" + @order.inspect
			render :action => 'show_products'
			return false
		end
		return false if !allowed(@order_type_id, 'view')
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @orders }
    end
  end
  def show_todays_sales
		return false if !allowed(1, 'view')
		@order_type_id=1
    @orders = Order.search_todays_sales(params[:search], params[:page])
		if @orders.length == 1
			@order=@orders[0]
			return false if !allowed(@order.order_type_id, 'view')
			render :action => 'show_products'
			return false
		end
    respond_to do |format|
      format.html { render :action => 'index' }
      format.xml  { render :xml => @orders }
    end
  end
  def pay_off
		@order = Order.find(params[:id])
    if @order
      @order.pay_off
			flash[:info] = "Pago se ha hecho exitosamente"
    else
			flash[:error] = "No hay ningun pedido en el sistema con ese numero"
    end
    redirect_back_or_default(@order.client)
    return false
  end
	# GET /orders/create_batch
  # GET /orders/create_batch.xml
  def create_batch
  	#logger.debug "starting create batch"
		if create_orders
			respond_to do |format|
		    flash[:notice] = 'Pedidos han sido creados exitosamente.'
        format.html { redirect_to('/orders/show_batch') }
		  end
		else
			respond_to do |format|
		    format.html {redirect_to('/inventories')}
		  end
		end
  end
  def show_receipts
    @order = Order.find(params[:id])
    return false if !allowed(@order.order_type_id, 'view')
    if @order.receipts.length < 1
      # receipts for this order have not been generated yet
      redirect_to(new_receipt_url(@order))
  		return false
    end
    @receipts=@order.receipts
    respond_to do |format|
      format.html # show_receipts.html.erb
      format.xml  { render :xml => @orders }
    end
  end
  def create_orders
  	#logger.debug "starting create orders"
  	
  	for o in Order.find(:all, :conditions =>'last_batch=True')
  		o.last_batch=false
  		o.save
  	end
  	
  	#logger.debug "about to go through vendors"
  	@vendors = Entity.find(:all, :order => "name", :conditions =>"entity_type_id=1")
  	for v in @vendors
  		#logger.debug "looking at " + v.name
  		order_made=0
  		for p in Product.find_all_by_vendor_id(v.id)
  			to_order=p.to_order
  			logger.debug "product:" + p.id.to_s + " "+ p.name + " to order:" + to_order.to_s
  			if (to_order || 0) > 0
  				logger.debug "ordering product"
  				if order_made==0
  					#puts"creating new order for " + v.name
  					o=Order.new(:vendor=>v, :client=>current_user.location, :user=>current_user, :last_batch=>true, :order_type_id => 2, :created_at=>User.current_user.today)
  					logger.debug "============> o.new=#{o.inspect}"
  					o.save
  					logger.debug "============> o.save=#{o.inspect}"
  					order_made=1
  				end	
  				if p.serialized
  					for i in (1..to_order)
							l=o.lines.new(:product=>p, :quantity=>1,:price=>p.price)
							logger.debug "l.new(s)=#{l.inspect}"
							l.save
							logger.debug "l.save(s)=#{l.inspect}"
						end
  				else
						l=o.lines.new(:product=>p, :quantity=>to_order,:price=>p.price)
						logger.debug "l.new=#{l.inspect}"
						l.save
						logger.debug "l.save=#{l.inspect}"
  				end
  				##logger.debug "done ordering product"
  				p.to_order=0
  			end
  		end
  		order_made=0
  	end
  	return Order.find_by_last_batch(true)
  end
  # GET /orders/show_batch
  # GET /orders/show_batch.xml
  def show_batch
		@orders = Order.search_purchase_batch(params[:search], params[:page])
		@order_type_id	= 2
		respond_to do |format|
      format.html {render :template=> "/orders/index"}
      format.xml  { render :xml => @orders }
    end
  end
  # GET /orders/1
  # GET /orders/1.xml
  def show
    @order = Order.find(params[:id])
    if @order.order_type_id == 5
    	redirect_to(physical_count_url(params[:id]))
    	return false
    end
		return false if !allowed(@order.order_type_id, 'view')
    respond_to do |format|
      format.html { render :template => "/orders/show_products" }
      format.xml  { render :xml => @order }
    end
  end
	def show_history
    @order = Order.find(params[:id])
		return false if !allowed(@order.order_type_id, 'view')
    respond_to do |format|
      format.html # show_history.html.erb
      format.xml  { render :xml => @order }
    end
  end

	def show_payments
    @order = Order.find(params[:id])
		return false if !allowed(@order.order_type_id, 'view')
    @payments = @order.recent_payments(10)
    respond_to do |format|
      format.html # show_payments.html.erb
      format.xml  { render :xml => @order }
    end
  end
  # GET /orders/new
  # GET /orders/new.xml
  def new
    @order = Order.new(:created_at=>User.current_user.today, :receipt_number=>(User.current_user.location.next_receipt_number||''))
		@order_type_id = params[:order_type_id] || 0
		if @order_type_id == 1
			@order.client_id = 1213
		end
		return false if !allowed(params[:order_type_id], 'edit')
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @order }
    end
  end
	def new_purchase
    @order = Order.new(:created_at=>User.current_user.today)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @order }
    end
  end
  def new_sale
    @order = Order.new(:created_at=>User.current_user.today)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @order }
    end
  end
  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
    return false if !allowed(@order.order_type_id, 'edit')
  end

  # POST /orders
  # POST /orders.xml
  def create
    @order = Order.new(:order_type_id => params["order"]["order_type_id"], :created_at=>User.current_user.today)
    puts "heres the order we just created: " + @order.inspect
    @order.attributes = params["order"]
    return false if !allowed(@order.order_type_id, 'edit')
    User.current_user.location.next_receipt_number=params["order"]["receipt_number"].to_i
    @order.create_all_lines(params[:new_lines]) # we're not saving the lines yet, just filling them out
    logger.debug "finished updating lines"
    respond_to do |format|
      if @order.save
      	flash[:notice] = 'Pedido ha sido creado exitosamente.'
        format.html { redirect_to(@order) }
        format.xml  { render :xml => @order, :status => :created, :location => @order }
      else
      	logger.debug "unable to save new order"
      	logger.debug "ORDERS ERRORS" + @order.errors.inspect
      	@order.lines.each {|l| logger.debug "LINES ERRORS" + l.errors.inspect}
				
				@order.errors.each {|e| logger.debug "ORDER ERROR" + e.to_s}
				@order.lines.each {|l| l.errors.each {|e| logger.debug "LINE ERROR" + e.to_s}}
				@order.errors.each do |error|
					logger.debug "error[0]=#{error[0].to_s}"
					if error[0] == "lines"
						errors.delete(error)
					end
				end
        format.html { render :action => "new" }
        format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /orders/1
  # PUT /orders/1.xml
  def update
    @order = Order.find(params[:id])
    params[:order][:created_at]=untranslate_month(params[:order][:created_at]) if params[:order][:created_at]
    params[:order][:received]=untranslate_month(params[:order][:received]) if params[:order][:received]
    return false if !allowed(@order.order_type_id, 'edit')
    errors = false
    if @order.deleted
        redirect_back_or_default('/orders')
		flash[:error] = "Este pedido ha sido anulado. Ya no se puede cambiar"
		return false
    end
    @order.update_all_lines(params[:new_lines], params[:existing_lines])
		errors = true if !@order.update_attributes(params[:order])
		if params[:submit_type] == 'post' and !errors
			errors = true if !@order.post
		end
    respond_to do |format|
      if !errors
        flash[:notice] = 'Pedido ha sido actualizado exitosamente.'
        format.html { redirect_to(@order) }
        format.xml  { head :ok }
      else
      	logger.debug "saving order didnt work"
        format.html { render :action => "edit" }
        format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.xml
  def destroy
    @order = Order.find(params[:id])
    return false if !allowed(@order.order_type_id, 'edit')
    sucess=@order.anull
    respond_to do |format|
        if sucess
          flash[:notice] = 'Pedido ha sido anulado exitosamente.'
          format.html { redirect_to(@order) }
          format.xml  { head :ok }
        else
            redirect_to(@order)
		    	flash[:error] = "No se pudo anular el pedido"
		    return false
        end
    end
  end
  
  def erase
    @order = Order.find(params[:id])
    errors=false
    for receipt in @order.receipts
    	errors=true if !receipt.destroy
    end
    if !errors
    	errors=true if !@order.destroy
    end
    if errors
			flash[:info] = "No se pudo borrar la pedido" 
			redirect_to(@order)
		else
			flash[:info] = "El pedido ha sido borrado existosamente" 
			redirect_to(orders_url)
		end
  end
end
