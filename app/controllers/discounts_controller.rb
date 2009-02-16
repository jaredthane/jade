class DiscountsController < ApplicationController
  # GET /discounts
  # GET /discounts.xml
  
	before_filter :login_required
	access_control [:new, :create, :update, :edit, :destroy] => '(gerente | admin)' 
  def index
    #@discounts = Product.find(:all)
		@discounts = Product.search_for_discounts(params[:search], params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @discounts }
      format.js
    end
  end

  # GET /discounts/1
  # GET /discounts/1.xml
  def show
    @discount = Product.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @discount }
    end
  end

  # GET /discounts/new
  # GET /discounts/new.xml
  def new
    @discount = Product.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @discount }
    end
  end

  # GET /discounts/1/edit
  def edit
    @discount = Product.find(params[:id])
  end

  # POST /discounts
  # POST /discounts.xml
  def create
    @discount = Product.new(params[:product])
		for e in Entity.find_all_by_entity_type_id(3)
    	i=Inventory.new(:entity=>e, :product=>@discount, :quantity=>0, :min=>0, :max=>0, :to_order=>0)
    	i.save
    end
    respond_to do |format|
      if @discount.save
        flash[:notice] = 'Unidad ha sido creada exitosamente.'
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
#puts "running discioutns update"
  	@product = Product.find(params[:id])
		if  @product.update_attributes(params[:product])
			flash[:notice] = 'Producto ha sido actualizado exitosamente.'
		end
		redirect_to(discount_path(@product))

  end
  
  
  # DELETE /discounts/1
  # DELETE /discounts/1.xml
  def destroy
    @discount = Product.find(params[:id])
    @discount.destroy

    respond_to do |format|
      format.html { redirect_to(discounts_url) }
      format.xml  { head :ok }
    end
  end
end
