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

  # GET /lines/new
  # GET /lines/new.xml
  def new
    @line = Line.new()
    @line.bar_code = params[:line][:bar_code]
    @line.quantity = 1
    
		#if @line.product
		  if !@line.product.serialized
			  @line.received = current_user.default_received
			end
	 	  puts "default received =" + current_user.default_received.to_s
		  respond_to do |wants|
		    wants.html do
		      redirect_to '/orders/' + @line.order_id.to_s + '/edit'
		    end
		    wants.js
		  end
		#else
		# 	render :action => 'error'
		#end
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
