class OrdersController < ApplicationController
	before_filter :login_required
  # GET /orders
  # GET /orders.xml
  def index
    #@orders = Order.find(:all)
		@order_type = params[:order_type] || 'all'
		case @order_type
		when 'all'
			@orders = Order.search(params[:search], params[:page])
		when 'sales'
			@orders = Order.search_sales(params[:search], params[:page])
		when 'purchases'
			@orders = Order.search_purchases(params[:search], params[:page])
		end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @orders }
    end
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
		    format.html {redirect_to('/products/bulk_edit')}
		  end
		end
  end
  def create_orders
  	#logger.debug "starting create orders"
  	@vendors = Entity.find(:all, :order => "name", :conditions =>"entity_type_id=1")
  	for o in Order.find(:all, :conditions =>'last_batch=True')
  		o.last_batch=false
  		o.save
  	end
  	#logger.debug "about to go through vendors"
  	for v in @vendors
  		#logger.debug "looking at " + v.name
  		order_made=0
  		condition='vendor_id=' + v.id.to_s
  		for p in Product.find(:all, :conditions => condition)
  			to_order=p.to_order
  			##logger.debug "product:" + p.id.to_s + " "+ p.name + " to order:" + to_order.to_s
  			if (to_order || 0) > 0
  				##logger.debug "ordering product"
  				if order_made==0
  					#puts"creating new order for " + v.name
  					o=Order.new(:vendor=>v, :client=>current_user.location, :user=>current_user, :last_batch=>true)
  					o.save
  					order_made=1
  				end	
  				if p.serialized
  					for i in (1..to_order)
							l=o.lines.new(:product=>p, :quantity=>1,:price=>p.price)
							l.save
						end
  				else
						l=o.lines.new(:product=>p, :quantity=>to_order,:price=>p.price)
						l.save
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
		@orders = Order.search_batch(params[:search], params[:page])
		@order_type	= 'purchases'
		respond_to do |format|
      format.html {render :template=> "/orders/index"}
      format.xml  { render :xml => @orders }
    end
  end
  # GET /orders/1
  # GET /orders/1.xml
  def show
    @order = Order.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @order }
    end
  end
	def show_history
    @order = Order.find(params[:id])
		
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @order }
    end
  end

  # GET /orders/new
  # GET /orders/new.xml
  def new
    @order = Order.new
		@order_type = params[:order_type] || 'all'
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @order }
    end
  end
	def new_purchase
    @order = Order.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @order }
    end
  end
  def new_sale
    @order = Order.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @order }
    end
  end
  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
  end

  # POST /orders
  # POST /orders.xml
  def create
    @order = Order.new(params["order"])
    respond_to do |format|
      if @order.save
      	list= params['new_lines'] || []
      	for l in list
      		new_line = Line.new(:order_id=>@order.id)
      		#new_line.product_name = l[:product_name]  		
      		new_line.product_id = l[:product_id]  	
  				new_line.quantity = l[:quantity]  
  				#new_line.set_serial_number_with_product(l[:serial_number], l[:product_name])
      		#logger.debug "product id:   ->" + l[:product_name]
      		logger.debug "new_line.warranty.to_s before=" + new_line.warranty.to_s.to_s
      		new_line.update_attributes(l)
      		logger.debug "new_line.warranty.to_s= after" + new_line.warranty.to_s.to_s
      		@order.lines << new_line
      	end
      	@order.check_for_discounts if @order.order_type == 'sales'
        flash[:notice] = 'Pedido ha sido creado exitosamente.'
        format.html { redirect_to(@order) }
        format.xml  { render :xml => @order, :status => :created, :location => @order }
      else
      	#logger.debug "unable to save new order"
				#@order.errors.each {|e| #logger.debug e.to_s}
				#@order.lines.errors.each {|e| #logger.debug e.to_s}
        format.html { render :action => "new" }
        format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /orders/1
  # PUT /orders/1.xml
  def update
    @order = Order.find(params[:id])
    
    #Update existing lines
    for l in @order.lines
			#logger.debug "l.id=" + l.id.to_s
			##logger.debug "params['existing_lines'][l.id.to_s]=" + params['existing_lines'][l.id.to_s].to_s
			if params['existing_lines'][l.id.to_s]
				logger.debug "setting attribs for line #{l.id}"
				logger.debug "l.warranty before=#{l.warranty.to_s}"
				l.attributes = params['existing_lines'][l.id.to_s]
				logger.debug "l.warranty afterz=#{l.warranty.to_s}"
			else
				logger.debug "deleting line #{l.id}"
				@order.lines.delete(l)
			end
		end
		
		# Update New lines
		list= params['new_lines'] || []
  	for l in list
  		new_line = Line.new(:order_id=>@order.id)
  		#new_line.product_name = l[:product_name]  
  		new_line.product_id = l[:product_id]		
  		new_line.quantity = l[:quantity]
  		new_line.attributes=l  
  		logger.debug "about to push #{new_line.inspect}"  	
  		@order.lines.push(new_line)
  	end
		#params['new_lines'].each { |l| @order.lines << Line.new(l) } if params['new_lines']
		
    #params['existing_lines'].each_value  { |l| #logger.debug "l['id']=" + l['id'].to_s; Line.find(l['id']).attributes = l } if params['existing_lines']
		for l in @order.lines
			logger.debug "l=#{l.inspect}"
		end
    respond_to do |format|
      if @order.update_attributes(params[:order])
    		logger.debug "saving order worked"
    		$audit.info "changed order #{@order.id}"
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
    @order.destroy

    respond_to do |format|
      format.html { redirect_to(orders_url) }
      format.xml  { head :ok }
    end
  end
end
