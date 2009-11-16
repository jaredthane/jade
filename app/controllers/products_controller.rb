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
	access_control [:new, :create, :update, :edit, :bulk_edit, :bulk_update, :clear_quantities, :recommend_quantities] => '(Gerente | Admin | Compras)' 
	access_control [:update_prices, :edit_prices, :update_product] => '(Gerente | Admin)' 
	access_control [:destroy] => '(Admin)'
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
		
				#redirect_to('/products/' + @products[0].to_s)
		
    respond_to do |format|
      format.html {
        if @products.length == 1
			    @product=@products[0]
			    render :action => 'show'
			    return false
			  end
      }
      format.xml
      format.js
    end
  end
  def show_barcode
  	@product = Product.find(params[:id])
  	render :layout => false
  end
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
		@product.unit_id=1
		@product.product_type_id=1
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
    @product.create_related_values(params[:product][:default_cost], params[:product][:static_price], params[:product][:relative_price])
    respond_to do |format|
      if @product.save
      	@product.update_attributes(params[:product])
        flash[:notice] = 'Producto ha sido creado exitosamente.'
        format.html { redirect_to(@product) }
        format.xml  { render :xml => @product, :status => :created, :location => @product }
      else
      puts " There were errors creating product:"
        for error in @product.errors
          puts error
        end
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
