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
				return false if !check_user(User::CHANGE_SALES,'No tiene los derechos suficientes para cambiar ventas')
			elsif action=="view"
				return false if !check_user(User::VIEW_SALES,'No tiene los derechos suficientes para ver ventas')
			end
	  when 2
	  	return false if !check_user(User::VIEW_PURCHASES,'No tiene los derechos suficientes para ver compras')
	  when 3
	  	if action=="edit"
				return false if !check_user(User::CHANGE_INTERNAL_CONSUMPTION,'No tiene los derechos suficientes para cambiar consumos  internos')
			elsif action=="view"
				return false if !check_user(User::VIEW_INTERNAL_CONSUMPTION,'No tiene los derechos suficientes para ver consumos internos')
			end
    end  
    return true  
	end
  def index
    logger.info params.inspect
		return false if !allowed(params[:order_type_id], 'view')

		@order_type_id=params[:order_type_id]
		logger.debug "@order_type_id=#{@order_type_id.to_s}"
    @site=User.current_user.location
  	@sites=(params[:sites] ||[current_user.location_id])
#  	@search_path = SEARCH_PATHS[@order_type_id]
  	params[:page]=(params[:page]||1)
	  @from=(untranslate_month(params[:from])||Date.today)
    @till=(untranslate_month(params[:till])||Date.today)
    if params[:pdf]=='1'
      @orders=Order.search(params[:search], @order_type_id, @from, @till)
      params[:format] = 'pdf'
    else
      @orders=Order.search(params[:search], @order_type_id, @from, @till, params[:page])
      if @orders.length == 1
			  @order=@orders[0]
			  @payments = @order.recent_payments(10)
			  return false if !allowed(@order.order_type_id, 'view')
			  render :action => 'show'
			  return false
		  end
    end
    if @order_type_id==5
    	render :template=>'counts/index'
    	return false
    end
    respond_to do |format|
      format.html # index.html.erb
      format.pdf {
        prawnto :prawn => { :page_size => 'LETTER'}
      }
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
  def show_receipt
    @order = Order.find(params[:id])
    return false if !allowed(@order.order_type_id, 'view')
    if FileTest.exists?(@order.receipt_filename||'')
		 	send_file @order.receipt_filename, :type => 'application/pdf', :disposition => 'inline'  #, :x_sendfile=>true
	    #send_data @receipt.filename, :disposition => 'inline'
	    # This is good for if the user wants to download the file
		else
			redirect_back_or_default(orders_url)
			flash[:error] = "Esta factura no se encuentra entre los archivos"
	    return false
		end
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
    @order = Order.find_by_id(params[:id])
    if !@order
    	flash[:error] = "El pedido especificado no se encuentra entre los archivos."
    	redirect_back_or_default(orders_url)
    	return false
    end
    @payments = @order.recent_payments(10)
		return false if !allowed(@order.order_type_id, 'view')
    if @order.order_type_id == 5
    	render :template=>'counts/show'
    	return false
    end
    respond_to do |format|
      format.html 
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
		return false if !allowed(params[:order_type_id], 'edit')
		@order_type_id=params[:order_type_id]
    @order = Order.new(:created_at=>User.current_user.today, :receipt_number=>(User.current_user.location.next_receipt_number||''))
		if @order_type_id == 1
			@order.client_id = 3
		elsif @order_type_id == 2
			@order.vendor_id = 4
		end
    if @order_type_id==5
    	render :template=>'counts/new'
    	return false
    end
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @order }
    end
  end
#	def new_purchase
#    @order = Order.new(:created_at=>User.current_user.today, :vendor_id=>4)

#    respond_to do |format|
#      format.html # new.html.erb
#      format.xml  { render :xml => @order }
#    end
#  end
#  def new_sale
#    @order = Order.new(:created_at=>User.current_user.today, :client_id=>3)

#    respond_to do |format|
#      format.html # new.html.erb
#      format.xml  { render :xml => @order }
#    end
#  end
  # GET /orders/1/edit
  
  def post
		return false if !check_user(User::POST_COUNTS,'No tiene los derechos suficientes para procesar cuentas fisicas.')
    @order = Order.find(params[:id])
    if @order.post
      flash[:notice] = 'Cuenta Fisica ha sido procesado exitosamente.'
      redirect_to(@order)
    else
      format.html { render :action => "edit" }
    end
  end
  def edit
    @order = Order.find(params[:id])
    return false if !allowed(@order.order_type_id, 'edit')
    if @order.order_type_id == 5
    	render :template=>'counts/edit'
    	return false
    end
  end
  def new_nul_number
  end
  def create_null_number
  end
  def generate_receipt(order)
  	order.receipt_filename="#{RAILS_ROOT}/invoice_pdfs/{order.id}.pdf"
  	prawnto :prawn => {:skip_page_creation=>true}
	  pdf_string = render_to_string :template => 'orders/receipt.pdf.prawn', :layout => false
		File.open(order.receipt_filename, 'w') { |f| f.write(pdf_string) }
		User.current_user.location.next_receipt_number=order.receipt_number.to_i+1
  	User.current_user.location.save
	end
  # POST /orders
  # POST /orders.xml
  def create
    return false if !allowed(params["order"]["order_type_id"], 'edit')
    params[:order][:created_at]=untranslate_month(params[:order][:created_at]) if params[:order][:created_at]
    params[:order][:received]=untranslate_month(params[:order][:received]) if params[:order][:received]

    @order = Order.new(:order_type_id => params["order"]["order_type_id"], :created_at=>User.current_user.today)
    @order.attrs = params["order"]
    logger.debug 'params["order"]["lines"]=#{params["order"]["lines"].to_s}'
    logger.debug "@order.lines=#{@order.lines.to_s}"
#    logger.info "heres the order we just created: " + @order.inspect
    this_receipt = params["order"]["number"].to_s
    next_receipt=("%0" + this_receipt.length.to_s + "d") % (this_receipt.to_i + 1)
    User.current_user.location.next_receipt_number = next_receipt
#    @order.create_all_lines(params[:new_lines]) # we're not saving the lines yet, just filling them out
#    logger.info "finished updating lines"
		errors = false
		errors = true if !@order.save
		if params[:submit_type] == 'post' and !errors
			errors = true if !@order.post
		end
    respond_to do |format|
      if !errors
        generate_receipt(@order) if @order.order_type_id=1
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
    puts params.inspect
    @order = Order.find(params[:id])
    return false if !allowed(@order.order_type_id, 'edit')
    params[:order][:created_at]=untranslate_month(params[:order][:created_at]) if params[:order][:created_at]
    params[:order][:received]=untranslate_month(params[:order][:received]) if params[:order][:received]
    errors = false
#    logger.info "dumping lines before"
#    logger.info @order.lines.inspect
    @order.attrs=params[:order]
#    logger.info "dumping lines middle"
#    logger.info @order.lines.inspect
		errors = true if !@order.save
#    logger.info "dumping lines after"
#    logger.info @order.lines.inspect
		if params[:submit_type] == 'post' and !errors
			errors = true if !@order.post
		end
		
    generate_receipt(@order)
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
