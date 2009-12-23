# Jade Inventory Control System
#Copyright (C) 2009  Jared T. Martin

#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.

#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied category of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.

#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.


class ProductCategoriesController < ApplicationController
  def index
  	if params[:q]
  		search=params[:q] 
  	else
    	search=(params[:search]||'')
    end
		@product_categories = ProductCategory.search(search, params[:page])
    respond_to do |format|
      format.html # show.html.erb
      format.js # index.html.erb
    end
  end
  def show
  	@search=params[:search] || ""
    @products = Product.find_all_by_product_category_id(params[:id])
		@product_category = ProductCategory.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @products }
    end
  end
  # GET /categories/new
  # GET /categories/new.xml
  def new
    @category = ProductCategory.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @category }
    end
  end

  # GET /categories/1/edit
  def edit
    @category = ProductCategory.find(params[:id])
  end

  # POST /categories
  # POST /categories.xml
  def create
    @category = ProductCategory.new(params[:product_category])

    respond_to do |format|
      if @category.save
        flash[:notice] = 'Garantía ha sido creado exitosamente.'
        format.html { redirect_to(product_categories_url) }
        format.xml  { render :xml => @categories, :status => :created, :location => @category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /categories/1
  # PUT /categories/1.xml
  def update
    @product_category = ProductCategory.find(params[:id])
    respond_to do |format|
      if @product_category.update_attributes(params[:product_category])
        flash[:notice] = 'Categoria ha sido actualizado exitosamente.'
        format.html { render :action => "show" }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @product_category.errors, :status => :unprocessable_entity }
      end
    end
  end
  def destroy
  	@product_category = ProductCategory.find(params[:id])
   	@product_category.destroy

    respond_to do |format|
      format.html { redirect_to(products_url) }
      format.xml  { head :ok }
    end
  end
end
