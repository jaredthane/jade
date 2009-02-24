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


class ProductsController < ApplicationController
  # GET /products
  # GET /products.xml
	before_filter :login_required
	#before_filter {privilege_required('sales')}
	access_control [:new, :create, :update, :edit, :bulk_edit, :bulk_update,:clear_quantities, :recommend_quantities] => '(gerente | admin | compras)' 
	access_control [:update_prices, :edit_prices, :update_product] => '(gerente | admin)' 
	access_control [:destroy] => '(admin)'
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
		puts @products.length
		if @products.length == 1
			@product=@products[0]
			render :action => 'show'
			return false
				#redirect_to('/products/' + @products[0].to_s)
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
		if @product.product_type_id==2
			redirect_to discount_path(@product)
			return false
		elsif @product.product_type_id==3
			redirect_to combo_path(@product)
			return false
		elsif @product.product_type_id==4
			redirect_to service_path(@product)
			return false
		end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @product }
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
    logger.debug "params:product:static_price= #{params[:product][:static_price].to_s}"
    logger.debug "params[:product][:relative_price]=#{params[:product][:relative_price].to_s}"
    for g in PriceGroup.all
    	if g == current_user.current_price_group
		  	Price.create(:product_id=>@product.id, :price_group_id => g.id, :fixed => params[:product][:static_price], :relative=>params[:product][:relative_price], :available => 1)
		  else
				Price.create(:product_id=>@product.id, :price_group_id => g.id, :fixed => params[:product][:static_price], :relative=>params[:product][:relative_price], :available => 0)
			end
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
  
  def update_product(attributes)
  	@products = Product.find(attributes[:id])
  	return @products.update_attributes(attributes)
  end
  # PUT /products/1
  # PUT /products/1.xml
  def update
		puts "running products update"
		
  	@product = Product.find(params[:id])
 		#Audit.info "changed product #{@product.inspect}"
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
