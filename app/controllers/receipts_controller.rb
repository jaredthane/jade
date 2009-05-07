class ReceiptsController < ApplicationController
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
  def consumidor_final
    prawnto :prawn => { :page_size => 'LETTER',#RECEIPT
					              :left_margin=>27,# was 27
										    :right_margin=>5,
										    :top_margin=>90, #was 90
										    :bottom_margin=>18}
    pdf_string = render_to_string :template => 'receipts/consumidor_final.pdf.prawn', :layout => false
    File.open("#{RAILS_ROOT}/invoice_pdfs/order #{@order.id}.pdf", 'w') { |f| f.write(pdf_string) }
  end
  def credito_fiscal
			prawnto :prawn => { :page_size => 'LETTER',
					              :left_margin=>27,# was 27
										    :right_margin=>5,
										    :top_margin=>90, #was 90
										    :bottom_margin=>5, 
										    :page_layout => :landscape }
    pdf_string = render_to_string :template => 'receipts/credito_fiscal.pdf.prawn', :layout => false
    File.open("#{RAILS_ROOT}/invoice_pdfs/order #{@order.id}.pdf", 'w') { |f| f.write(pdf_string) }
  end
  def new
    @order = Order.find(params[:id])
    if last=Receipt.last
      @next = (last.number || 0 )+1
    else
      @next=nil
    end
    return false if !allowed(@order.order_type_id, 'edit')
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @order }
    end
  end
  def create
    @order = Order.find(params[:id])
    return false if !allowed(@order.order_type_id, 'view')
    if !@order.receipt_printed
      return false if !allowed(@order.order_type_id, 'edit')
		  params[:format] = 'pdf'
		
		  # Prepare the data           ------------------------------------------------
		  @data=[]
		  total=0
		  for l in @order.lines
			  x = Object.new.extend(ActionView::Helpers::NumberHelper)
			  if l.product.serialized
				  if l.serialized_product
					  @data << [l.quantity.to_s, l.product.name + " - " + l.serialized_product.serial_number, x.number_to_currency(l.price), "", x.number_to_currency(l.total_price)]
				  end
			  else
				  @data << [l.quantity.to_s, l.product.name, x.number_to_currency(l.price), "", x.number_to_currency(l.total_price)]
			  end
			  total += l.total_price
			end  
		  # Call the appropriate format ------------------------------------------------
		  if @order.client.entity_type.id == 2
		    consumidor_final
		  else
		    credito_fiscal
		  end
		  flash[:info] = "La factura ha sido generada existosamente"
		end
		r=Receipt.create(:order=>params[:order_id], :number =>params[:number], :filename=>"#{RAILS_ROOT}/invoice_pdfs/order #{@order.id}.pdf")
		# Send the user the file ------------------------------------------------------
		redirect_to show_receipt_path(params[:id])
		return false
  end
  def show
    @order = Order.find(params[:id])
    if @order.receipt_printed
      send_file "#{RAILS_ROOT}/invoice_pdfs/order #{@order.id}.pdf", :type=>"application/pdf"#, :x_sendfile=>true
    else
      redirect_to new_receipt_path(params[:id])
      return false
    end
  end
end
