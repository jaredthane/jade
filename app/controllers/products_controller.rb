class ProductsController < ApplicationController
  # GET /products
  # GET /products.xml
	before_filter :login_required
	#before_filter {privilege_required('sales')}
	access_control [:new, :create, :update, :edit, :bulk_edit, :destroy] => '(gerente | admin | compras)' 

  def index
    #@products = Product.find(:all)
    @search=params[:search] || ""
    case params[:scope] 
    when 'all'
    	@products = Product.search_all(params[:search], params[:page])
    when 'services'
	    @products = Product.search_services(params[:search], params[:page])
    when 'name'
	    @products = Product.search_name(params[:search], params[:page])
    else
			@products = Product.search(params[:search], params[:page])
		end
    respond_to do |format|
      format.html # index.html.erb
      format.xml
      format.js
    end
  end

  # GET /products/1
  # GET /products/1.xml
  def show
    @product = Product.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @product }
      format.pdf { render :layout => false }
    end
  end

  # GET /products/new
  # GET /products/new.xml
  def new
    @product = Product.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @product }
    end
  end

  # GET /products/1/edit
  def edit
    @product = Product.find(params[:id])
  end

  # POST /products
  # POST /products.xml
  def create
    @product = Product.new(params[:product])
    for e in Entity.find_all_by_entity_type_id(3)
    	i=Inventory.new(:entity=>e, :product=>@product, :quantity=>0, :min=>0, :max=>0, :to_order=>0)
    	i.save
    end
    Warranty.create(:product=>@product, :price => 0, :months =>0)
    respond_to do |format|
      if @product.save
      	@product.update_attributes(params[:product])
        flash[:notice] = 'Producto ha sido creado exitosamente.'
        format.html { redirect_to(@product) }
        format.xml  { render :xml => @product, :status => :created, :location => @product }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
      end
    end
  end
  def clear_quantities
		@products = Product.search_wo_pagination(params[:search], params[:page])
		@search = params[:search] || ""
		for p in @products
			p.to_order = 0
		end
		redirect_to('/products/bulk_edit?search=' + @search)
	end
	def recommend_quantities
		@products = Product.search_all_wo_pagination(params[:search], params[:page])
		@search = params[:search] || ""
		for p in @products
			if current_user.location.inventory(p) < (p.min || 0)
				p.to_order = p.max
			end
		end
		redirect_to('/products/bulk_edit?search=' + @search)
	end
  def edit_prices
  	@products = Product.search(params[:search], params[:page])
    @action = 'prices' # for layout
		@search = params[:search] || ""
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @products }
    end
  end
  def update_prices
  	params[:products].each do |attributes|
			puts "attribs: " + attributes.inspect
			puts "attribs[1]: " + attributes[1].inspect
			@product = Product.find(attributes[0])
			puts "id:" + attributes[1][:id]
			@product.static_price = attributes[1][:static_price]
			@product.relative_price = attributes[1][:relative_price]
			@product.save
			#puts "products"
		end
		redirect_to('/products/edit_prices')
  end
  def bulk_edit
  	@products = Product.search_all_with_pages(params[:search], params[:page])
    @action = 'bulk' # for layout
		@search = params[:search] || ""
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @products }
    end
  end
  def bulk_update
		params[:products].each do |attributes|
			puts "attribs: " + attributes.to_s
			puts "attribs[1]: " + attributes[1].to_s
			@product = Product.find(attributes[0])
			puts "id:" + attributes[1][:id]
			@product.to_order = attributes[1][:to_order]
			puts "products"
		end
		redirect_to('/products/bulk_edit')
  end
  def update_product(attributes)
  	@products = Product.find(attributes[:id])
  	return @products.update_attributes(attributes)
  end
  # PUT /products/1
  # PUT /products/1.xml
  def update
		puts "running products update"
  	@product = Product.find(params[:id])
		if  @product.update_attributes(params[:product])
			flash[:notice] = 'Producto ha sido actualizado exitosamente.'
			redirect_to(@product)
		else
			render :action => "edit"
		end
		
  end





  # DELETE /products/1
  # DELETE /products/1.xml
  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    respond_to do |format|
      format.html { redirect_to(products_url) }
      format.xml  { head :ok }
    end
  end
end
