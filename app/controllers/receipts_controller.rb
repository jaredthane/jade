class ReceiptsController < ApplicationController
  include Formats
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
	def list_to_print
		@from=(params[:from] ||Date.today)
  	@till=(params[:till] ||Date.today)
		@receipts = Receipt.search_wo_pages(params[:search],@from, @till)
		@data=[]
		total=0
		x = Object.new.extend(ActionView::Helpers::NumberHelper)
		for receipt in @receipts
			if receipt.order.client.user
		  	username=receipt.order.client.user.name
		  else
		  	username=""
		  end
		  if receipt.deleted
		  	if receipt.created_at.to_date==receipt.deleted
		  		value='Anulado'
		  	else
		  		value=x.number_to_currency(-receipt.order.grand_total)
		  	end
		  else
		  	value=x.number_to_currency(receipt.order.grand_total)
		  end
		  @data << ["%05d" % receipt.number, receipt.order.client.name, receipt.order.received, value, username]
		end
		prawnto :prawn => { :page_size => 'LETTER'}
		params[:format] = 'pdf'
		respond_to do |format|
		  format.pdf { render :layout => false }
		end
	end
	def report
		@from=(params[:from] ||Date.today)
  	@till=(params[:till] ||Date.today)
		@receipts = Receipt.search_wo_pages(params[:search],@from, @till)
		@data=[]
		@site=User.current_user.location
		total=0
		x = Object.new.extend(ActionView::Helpers::NumberHelper)
		for receipt in @receipts
			if receipt.order.client.user
		  	username=receipt.order.client.user.name
		  else
		  	username=""
		  end
		  if receipt.deleted
		  	if receipt.created_at.to_date==receipt.deleted
		  		value='Anulado'
		  	else
		  		value=x.number_to_currency(-receipt.order.grand_total)
		  		total-=receipt.order.grand_total
		  	end
		  else
		  	value=x.number_to_currency(receipt.order.grand_total)
		  	total+=receipt.order.grand_total
		  end
		  @data << ["%05d" % receipt.number, receipt.created_at.to_date.to_s(:rfc822), receipt.order.client.name, value, username]
		  
		end
		@data << ["---", "---", "---", "---"]
		@data << ["", "", "Total", x.number_to_currency(total)]
		prawnto :prawn => { :page_size => 'LETTER'}
		params[:format] = 'pdf'
		respond_to do |format|
		  format.pdf { render :layout => false }
		end
	end
	def new_nul_number
	  if User.current_user.location
	  	@next = User.current_user.location.next_receipt_number
	  else
	    @next=nil
	  end
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @order }
    end
	end
	def create_nul_number
		o=Order.create(:vendor_id=>User.current_user.location_id, :client_id => 3, :user=> User.current_user, :order_type_id=>1, :receipt_printed=>params[:created_at].to_date, :created_at=>params[:created_at].to_date)
		r=Receipt.create(:order_id=>o.id, :number =>params[:number].to_i, :filename=>"#{RAILS_ROOT}/invoice_pdfs/receipt#{params[:id].to_i}.pdf", :user=> User.current_user, :created_at=>params[:created_at].to_date, :deleted=>params[:created_at].to_date)
		consumidor_final(r)
  	flash[:info] = "La factura ha sido anulado existosamente"
  	User.current_user.location.next_receipt_number=params[:number].to_i+1
  	User.current_user.location.save
    redirect_to receipts_url
    return false
	end
	def generate_receipts(list, start_id=1, created_at=User.current_user.today, nul=false)
		receipts_made=[]
		logger.debug "start_id is" + start_id.to_s
		for order in list
			if order.client.entity_type.id == 2
		    lines_per_receipt = CONSUMIDOR_FINAL_LINES_PER_RECEIPT
		  else
		    lines_per_receipt = CREDITO_FISCAL_LINES_PER_RECEIPT
		  end
		  lines_on_receipt = 0
		  for line in order.lines
		    if (lines_on_receipt >= lines_per_receipt) or (lines_on_receipt == 0) 
		      # Create a new receipt
		      r=Receipt.create(:order_id=>order.id, :number =>start_id, :filename=>"#{RAILS_ROOT}/invoice_pdfs/receipt#{start_id}.pdf", :user=> User.current_user, :created_at=>created_at)
		      receipts_made << r
		      o=Order.find(order.id)
		      o.receipt_printed=Date.today
		      o.save
		      lines_on_receipt = 0
		      start_id += 1
		    end
		    # Add line to receipt
		    line.receipt = r
		    line.save
		    lines_on_receipt += 1
		  end
		  # Generate the PDF's
		  for receipt in receipts_made #Order.find(order.id).receipts
		    if receipt.order.client.entity_type.id == 2
			    consumidor_final(receipt) # from the formats.rb file
			  else
			    credito_fiscal(receipt) # from the formats.rb file
			  end
		  end
		end	
		
		logger.debug "ending start_id is" + start_id.to_s
		return start_id
	end
############################################################################################
# DEPRECATED - DEPRECATED - DEPRECATED - DEPRECATED - DEPRECATED - DEPRECATED - DEPRECATED #
############################################################################################
#  def generate_receipts(order, start_id=1, force=false)
#  	receipts_made=[]
#  	logger.debug "Here" + order.receipts.length.to_s
#  	if order.receipts.length==0
#  		
#  	logger.debug "Here too"
#		  if order.client.entity_type.id == 2
#		    lines_per_receipt = CONSUMIDOR_FINAL_LINES_PER_RECEIPT
#		  else
#		    lines_per_receipt = CREDITO_FISCAL_LINES_PER_RECEIPT
#		  end
#		  lines_on_receipt = 0
#		  for line in order.lines
#		    logger.debug "lines_on_receipt" + lines_on_receipt.to_s
#		    if (lines_on_receipt >= lines_per_receipt) or (lines_on_receipt == 0) 
#		      # Create a new receipt
#		      r=Receipt.create(:order_id=>order.id, :number =>start_id, :filename=>"#{RAILS_ROOT}/invoice_pdfs/receipt#{start_id}.pdf", :user=> User.current_user)
#		      receipts_made << r
#		      o=Order.find(order.id)
#		      o.receipt_printed=Date.today
#		      o.save
#		      lines_on_receipt = 0
#		      logger.debug "reseting lines on receipt"
#		      start_id += 1
#		    end
#		    # Add line to receipt
#		    logger.debug "Setting line" + line.inspect
#		    line.receipt = r
#		    logger.debug "now with receipt_id" + line.inspect
#		    line.save
#		    logger.debug "double check it saved" + Line.find(line.id).inspect
#		    lines_on_receipt += 1
#		    
#		    logger.debug "+= 1 lines on receipt"
#		    logger.debug "lines on the receipt:" + Receipt.find(r.id).lines.inspect
#		    logger.debug "the receipt:" + Receipt.find(r.id).inspect
#		  end
#		  # Generate the PDF's
#		  for receipt in receipts_made #Order.find(order.id).receipts
#		    if receipt.order.client.entity_type.id == 2
#			    consumidor_final(receipt) # from the formats.rb file
#			  else
#			    credito_fiscal(receipt) # from the formats.rb file
#			  end
#		  end
#		end
#    return start_id
#  end
  def price_list
  @products = Product.search_all_wo_pagination(params[:search], params[:page])
  @data=[]
  total=0
  for p in @products
    x = Object.new.extend(ActionView::Helpers::NumberHelper)
    if p.name and p.description
      if p.name!='' and p.description!=''
        d=(p.name||'') + ' - ' + (p.description||'')
      else
        d=(p.name||'') + (p.description||'')
      end
    else
      d=(p.name||'') + (p.description||'')
    end
    if d.length > 203
       d=d[0..200] + "..."
    end
    @data << [d, x.number_to_currency(p.price)]
  end
  prawnto :prawn => { :page_size => 'LETTER'}
  params[:format] = 'pdf'
  respond_to do |format|
    format.pdf { render :layout => false }
  end
  
  end
  
  
  
#  def generate_receipts_for_up_to_date_accounts(start_id=1)
#  	list = Order.find(:all, :joins=>'inner join (select orders.id from (select * from (select * from orders where receipt_printed is null order by orders.id) as orders group by client_id) as orders inner join (select client_id as id from (select sum(amount_paid) as paid, sum(grand_total) as owed, client_id from orders group by client_id) as orders where paid>=owed) as clients on clients.id=orders.client_id) as ids on ids.id=orders.id')
##    list = Order.find(:all, :joins=>'inner join (select sales.orderid as id from (select * from (select id as orderid, client_id from orders where receipt_printed is null order by orders.id) as orders group by client_id) as sales inner join (select entities.id as clientid from entities left join (select * from (select id, client_id, amount_paid, grand_total from orders where receipt_printed is not null order by id DESC) as orders group by client_id) as orders on orders.client_id=entities.id where amount_paid >= grand_total OR orders.id is null) as clients on clientid=client_id) as unprinted on unprinted.id=orders.id')
#    
##    :joins=>'inner join (select min(orders.id) as id from orders inner join (select id, name from (select clients.id,clients.name, sum(line.price*line.quantity*(1+sales_tax)) as owed, sum(payments.presented-payments.returned) as paid from entities as clients left join orders on clients.id=orders.client_id and receipt_printed is not null left join `lines` as line on line.order_id=orders.id left join payments on payments.order_id=orders.id group by clients.id) as clients where paid>= owed or owed is null) as clients on clients.id=orders.client_id where (orders.receipt_printed is null) group by clients.id) as ready on ready.id=orders.id;')
#		for o in list
#			start_id = generate_receipts(o, start_id)
#		end
#  end
  def concat_pdf
    if @entity_type_id == 2
      @receipts = Receipt.credito_fiscal_today(params[:page])
    else
      @receipts = Receipt.consumidor_final_today(params[:page])
    end
    command = "gs -q -sPAPERSIZE=letter -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=#{RAILS_ROOT}/invoice_pdfs/concat.pdf "
    for receipt in @receipts
      command += receipt.filename+" "
    end
    logger.debug "Executing: "+ command
    system(command)
    send_file "#{RAILS_ROOT}/invoice_pdfs/concat.pdf", :type => 'application/pdf', :disposition => 'inline'  #, :x_sendfile=>true
  end
#  def show_today
#		@credito_fiscal_today = Receipt.search_credito_fiscal("",params[:page])
#		@consumidor_final_today = Receipt.search_consumidor_final("",params[:page])
#    respond_to do |format|
#      format.html 
#      format.xml  { render :xml => @receipts }
#    end
#  end
  def index
  	@from=(params[:from] ||Date.today)
  	@till=(params[:till] ||Date.today)
		@credito_fiscal_today = Receipt.search_credito_fiscal(params[:search],params[:page],@from, @till)
		@consumidor_final_today = Receipt.search_consumidor_final(params[:search],params[:page],@from, @till)
	
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @roles }
    end
  end
  def new
    @order = Order.find(params[:id])
    return false if !allowed(@order.order_type_id, 'edit')
	  if User.current_user.location
	  	@next = User.current_user.location.next_receipt_number
	  else
	    @next=nil
	  end
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @order }
    end
  end
  def create
    @order = Order.find(params[:id])
    return false if !allowed(@order.order_type_id, 'edit')
    @next = generate_receipts([@order], params[:number].to_i, params[:created_at])
    if @next 
    	flash[:info] = "La factura ha sido generada existosamente"
    	User.current_user.location.next_receipt_number=@next 
  	User.current_user.location.save
    end
    redirect_to show_receipts_url(@order)
    return false
  end
  
  def new_for_client
    @entity = Entity.find(params[:client_id])
    if !current_user.has_rights(['Admin','Gerente','Ventas'])
			redirect_back_or_default('/products')
			flash[:error] = "No tiene los derechos suficientes para ver los clientes"
  	end
	  if User.current_user.location
	  	@next = User.current_user.location.next_receipt_number
	  else
	    @next=nil
	  end
    respond_to do |format|
      format.html { render 'new'}
      format.xml  { render :xml => @order }
    end
  end
  def create_for_client
    @entity = Entity.find(params[:client_id])
  	if !current_user.has_rights(['Admin','Gerente','Ventas'])
			redirect_back_or_default('/products')
			flash[:error] = "No tiene los derechos suficientes para ver los clientes"
  	end
  	list=Order.find(:all, :conditions=>'receipt_printed is null AND client_id=' + @entity.id.to_s)
    @next = generate_receipts(list, params[:number].to_i)
    if @next 
    	flash[:info] = "Las facturas han sido generadas existosamente"
    	User.current_user.location.next_receipt_number=@next 
    	User.current_user.location.save
    end
    redirect_to entity_url(@entity)
    return false
  end
	def process_subscriptions
		if params[:search]
  	  subs=Subscription.to_process(params[:search])
  	elsif params[:client_id]
  	  @client=Entity.find(params[:client_id])
  	  subs=Subscription.to_process_client(@client)
	  elsif params[:sub_id]
  	  sub=Subscription.find(params[:sub_id])
  	  logger.debug "next order date='" + params[:next_order_date]+"'"
  	  sub.next_order_date=params[:next_order_date]
  	  logger.debug "next order date=" +sub.next_order_date.to_s
  	  sub.save
  	  logger.debug "next order date=" +Subscription.find(sub.id).next_order_date.to_s
  	  subs=[sub]
 	  end
 	  logger.debug "-------------->" + subs.inspect
  	orders = Subscription.process(subs, params[:num_months].to_i)
		flash[:info] = "Las suscripciones han sido provisionadas existosamente" if orders.length>0
  	if params[:number] != ''
			@next = generate_receipts(orders, params[:number].to_i)
		  if @next 
				logger.debug "@next is" + @next.to_s
		  	flash[:info] = "Las facturas han sido generadas existosamente"
		  	User.current_user.location.next_receipt_number=@next 
  	    User.current_user.location.save
		  end
		end
		if params[:client_id]
		  redirect_to @client
		  return false
		elsif params[:sub_id]
		  redirect_to subs[0].client
		  return false
		else
		  redirect_to receipts_path
		  return false
		end
  end
  def process_subscriptions_for_client
  	User.current_user=User.find(1) if !User.current_user
  	subs=Subscription.to_process(params[:search])
  	orders = Subscription.process(subs)
  	@next = generate_receipts(orders, params[:number].to_i)
  	User.current_user=nil if User.current_user.id=1
    if @next 
    	flash[:info] = "Las facturas han sido generadas existosamente"
    	if User.current_user
    	  if User.current_user.location
    	   	User.current_user.location.next_receipt_number=@next 
    	    User.current_user.location.save
    	  end
    	end
    end
    redirect_to receipts_path
    return false
  end
  def create_batch
    return false if !allowed(1, 'edit')
    list=Order.find(:all, :conditions=>'receipt_printed is null')
    @next = generate_receipts(list, params[:number].to_i)
    if @next 
    	flash[:info] = "Las facturas han sido generadas existosamente"
    	User.current_user.location.next_receipt_number=@next 
    	User.current_user.location.save
    end
    redirect_to todays_receipts_path
    return false
  end
  def new_batch
    return false if !allowed(1, 'edit')
	  if User.current_user.location
	  	@next = User.current_user.location.next_receipt_number
	  else
	    @next=nil
	  end
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @order }
    end
  end
  # GET /products/1/edit
  def edit
    @receipt = Receipt.find(params[:id])
  end
   
  def update
  	if !current_user.has_rights(['Admin','Edit Receipt'])
			redirect_back_or_default(receipts_url)
			flash[:error] = "No tiene los derechos suficientes para cambiar facturas"
			return false 
  	end
    @receipt = Receipt.find(params[:id])
	  if  @receipt.update_attributes(params[:receipt])
			flash[:notice] = 'Factura ha sido actualizado exitosamente.'
			redirect_back_or_default(receipts_url)
			return false 
		else
			render :action => "edit"
		end
  end
  def unpaid
    @receipts = Receipt.search_unpaid(params[:search], params[:page])
    
    respond_to do |format|
      format.html {render :locals=> {:title=>'Lista de Facturas No Canceladas'}}
      format.xml  { render :xml => @receipts }
    end
  end
  def show
    @receipt = Receipt.find(params[:id])
    if @receipt
    	if FileTest.exists?(@receipt.filename)
			 	send_file @receipt.filename, :type => 'application/pdf', :disposition => 'inline'  #, :x_sendfile=>true
		    #send_data @receipt.filename, :disposition => 'inline'
		    # This is good for if the user wants to download the file
			else
				redirect_back_or_default(sales_url)
				flash[:error] = "Esta factura no se encuentra entre los archivos"
		    return false
			end
      
    else
      redirect_back_or_default(sales_url)
			flash[:error] = "No hay ninguna factura en el sistema con ese numero"
      return false
    end
  end
  def destroy
    @receipt = Receipt.find(params[:id])
    @receipt.deleted=Date.today
    @receipt.save
		flash[:info] = "La factura han sido anulado"
    respond_to do |format|
      format.html { redirect_to(receipts_url) }
      format.xml  { head :ok }
    end
  end
end
