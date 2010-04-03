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
	def index
    #@products = Product.find(:all)
    @search = ((params[:search]||'') + ' ' + (params[:q]||'')).strip
    params[:scope]='name' if params[:format]=='js'
    if params[:format]=='pdf'
    	case params[:scope]
				when 'all'
					# We are adding params[:category_id] in case they clicked on the print link from the products category page
					@products = Product.search_all(@search, nil, params[:category_id]) 
				when 'services'
					@products = Product.search_services(@search, nil, params[:category_id])
				when 'category'
				@products = Product.search_categories(@search, nil, params[:category_id])
				when 'name'
					@products = Product.search_name(@search, nil, params[:category_id])
				else
					@products = Product.search(@search, nil, params[:category_id])
					@total = Product.total(@search, nil, params[:category_id])
					@date=User.current_user.today.to_date
			end
		else
		  case params[:scope]
				when 'all'
					@products = Product.search_all(@search, (params[:page] || 1), params[:category_id])
				when 'services'
					@products = Product.search_services(@search, (params[:page] || 1), params[:category_id])
				when 'category'
				@products = Product.search_categories(@search, (params[:page] || 1), params[:category_id])
				when 'name'
					@products = Product.search_name(@search, (params[:page] || 1))
				else
					@products = Product.search(@search, (params[:page] || 1), params[:category_id])
			end
		end
    respond_to do |format|
      format.html {
        if @products.length == 1
			    @product=@products[0]
			    render :action => 'show'
			    return false
			  end
      }
      format.pdf {
      	if params[:shelf_labels]
      		prawnto :prawn => {:template => 'shelf labels', :skip_page_creation=>true}
      	else
      		prawnto :prawn => {:skip_page_creation=>true}
      	end
      }
      format.js
    end
  end
  def shelf_labels
  	@search = ((params[:search]||'') + ' ' + (params[:q]||'')).strip
  	case params[:scope]
			when 'all'
				@products = Product.search_all(@search)
			when 'services'
				@products = Product.search_services(@search)
			when 'category'
				@products = Product.search_categories(@search)
			when 'name'
				@products = Product.search_name(@search)
			else
				@products = Product.search(@search)
		end
		respond_to do |format|
      format.pdf {prawnto :prawn => {:skip_page_creation=>true} }
    end
  end
#  def deactivate
#  	return false if !check_user(User::CHANGE_PRODUCTS,'No tiene los derechos suficientes para cambiar ventas')
#  	@product = Product.find(params[:id])
#  	x=nil
#  	until Product.find_by_name('DESACTIVADO: ' + @product.name + (x?"(" + x.to_s + ")":''))
#  		x=(x||0)+1
#  	end
#  	@product.name='DESACTIVADO: ' + @product.name + (x?"(" + x.to_s + ")":'')
#  	@product.save
#  	for p in Price.find_all_by_product_id(@product.id)
#  		p.available=false
#  		p.save
#  	end
#  end
  def show_barcode
  	@product = Product.find(params[:id])
  	render :layout => false
  end
	def price_list
		@products = Product.search_all_wo_pagination(params[:search], (params[:page] || 1))
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
    @product = Product.new(:vendor_id=>4)
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
  	if params[:product][:upc]==""
  		while Product.find_by_upc(User.current_user.location.next_bar_code)
  			User.current_user.location.next_bar_code=(User.current_user.location.next_bar_code.to_i + 1).to_s
	  	end
	  	params[:product][:upc]=User.current_user.location.next_bar_code
	  end
    @product = Product.new(params[:product])
    respond_to do |format|
      if @product.save
      	@product.create_related_values(params[:product][:default_cost], params[:product][:static_price], params[:product][:relative_price])
	  		User.current_user.location.save if @product.upc==User.current_user.location.next_bar_code
#      	@product.update_attributes(params[:product])
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
		params[:product][:upc]=User.current_user.location.next_bar_code if params[:product][:upc]==""
  	@product = Product.find(params[:id])
 		#Audit.info "changed product #{@product.inspect}"
		if  @product.update_attributes(params[:product])
    	if @product.upc==User.current_user.location.next_bar_code
				User.current_user.location.next_bar_code=(User.current_user.location.next_bar_code.to_i + 1).to_s
				User.current_user.location.save
			end
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
