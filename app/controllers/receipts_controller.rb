class ReceiptsController < ApplicationController
  include Formats
  def allowed(order_type_id, action)
		case (order_type_id)
		  when 1
		  	if action=="edit"
					if !current_user.has_rights(['admin','gerente','ventas'])
						redirect_back_or_default('/products')
						flash[:error] = "No tiene los derechos suficientes para cambiar las ventas"
						return false
					end
				elsif action=="view"
					if !current_user.has_rights(['admin','gerente','ventas','compras','inventario'])
						redirect_back_or_default('/products')
						flash[:error] = "No tiene los derechos suficientes para ver las ventas"
						return false
					end
				end
		  when 2
		  	if !current_user.has_rights(['admin','compras','gerente','inventario'])
					redirect_back_or_default('/products')
					flash[:error] = "No tiene los derechos suficientes para ver las compras"
						return false
		  	end
		  when 3
		  	if action=="edit"
					if !current_user.has_rights(['admin','gerente','ventas','inventario'])
						redirect_back_or_default('/products')
						flash[:error] = "No tiene los derechos suficientes para cambiar el uso interno"
						return false
					end
				elsif action=="view"
					if !current_user.has_rights(['admin','gerente','ventas','compras','inventario'])
						redirect_back_or_default('/products')
						flash[:error] = "No tiene los derechos suficientes para ver el uso interno"
						return false
					end
				end
    end  
    return true  
	end
	
  def generate_receipts(order, start_id=1)
    if order.client.entity_type.id == 2
      lines_per_receipt = CONSUMIDOR_FINAL_LINES_PER_RECIEPT
    else
      lines_per_receipt = CREDITO_FISCAL_LINES_PER_RECIEPT
    end
    lines_on_receipt = 0
    for line in order.lines
      logger.debug "lines_on_receipt" + lines_on_receipt.to_s
      if (lines_on_receipt >= lines_per_receipt) or (lines_on_receipt == 0) 
        # Create a new receipt
        r=Receipt.create(:order_id=>order.id, :number =>start_id, :filename=>"#{RAILS_ROOT}/invoice_pdfs/receipt #{start_id}.pdf", :user=> User.current_user)
        lines_on_receipt = 0
        logger.debug "reseting lines on receipt"
        start_id += 1
      end
      # Add line to receipt
      logger.debug "Setting line" + line.inspect
      line.receipt = r
      logger.debug "now with receipt_id" + line.inspect
      line.save
      logger.debug "double check it saved" + Line.find(line.id).inspect
      lines_on_receipt += 1
      
      logger.debug "+= 1 lines on receipt"
      logger.debug "lines on the receipt:" + Receipt.find(r.id).lines.inspect
      logger.debug "the receipt:" + Receipt.find(r.id).inspect
    end
    # Generate the PDF's
    for receipt in Order.find(order.id).receipts
      if receipt.order.client.entity_type.id == 2
	      consumidor_final(receipt) # from the formats.rb file
	    else
	      credito_fiscal(receipt) # from the formats.rb file
	    end
    end
  end
  def new
    @order = Order.find(params[:id])
    return false if !allowed(@order.order_type_id, 'edit')
    if last=Receipt.last
      logger.debug "Strange... Couldn't find the last receipt made, assuming there are none"
      @next = (last.number.to_i || 0 )+1
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
    flash[:info] = "La factura ha sido generada existosamente" if generate_receipts(@order, params[:number].to_i)
    redirect_to show_receipts_url(@order)
    return false
  end
def show
    @receipt = Receipt.find(params[:id])
    if @receipt
      #send_data @receipt.filename, :disposition => 'inline'
      # This is good for if the user wants to download the file
      send_file @receipt.filename, :type => 'application/pdf', :disposition => 'inline'
  #, :x_sendfile=>true
    else
      redirect_back_or_default(sales_url)
			flash[:error] = "No hay ninguna factura en el sistema con ese numero"
      return false
    end
  end
end
