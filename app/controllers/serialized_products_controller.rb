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


class SerializedProductsController < ApplicationController
  # GET /serialized_products
  # GET /serialized_products.xml
  def index
    @serialized_products = SerializedProduct.search(params[:search], params[:page])
		if @serialized_products.length == 1
			@serialized_product=@serialized_products[0]
			render :action => 'show'
			return false
				#redirect_to('/products/' + @products[0].to_s)
		end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @serialized_products }
    end
  end

  # GET /serialized_products/1
  # GET /serialized_products/1.xml
  def show
    @serialized_product = SerializedProduct.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @serialized_product }
    end
  end

  # GET /serialized_products/new
  # GET /serialized_products/new.xml
  def new
    @serialized_product = SerializedProduct.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @serialized_product }
    end
  end

  # GET /serialized_products/1/edit
  def edit
    @serialized_product = SerializedProduct.find(params[:id])
  end

  # POST /serialized_products
  # POST /serialized_products.xml
  def create
    @serialized_product = SerializedProduct.new(params[:serialized_product])

    respond_to do |format|
      if @serialized_product.save
        flash[:notice] = 'SerializedProduct was successfully created.'
        format.html { redirect_to(@serialized_product) }
        format.xml  { render :xml => @serialized_product, :status => :created, :location => @serialized_product }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @serialized_product.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /serialized_products/1
  # PUT /serialized_products/1.xml
  def update
    @serialized_product = SerializedProduct.find(params[:id])

    respond_to do |format|
      if @serialized_product.update_attributes(params[:serialized_product])
        flash[:notice] = 'SerializedProduct was successfully updated.'
        format.html { redirect_to(@serialized_product) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @serialized_product.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /serialized_products/1
  # DELETE /serialized_products/1.xml
  def destroy
    @serialized_product = SerializedProduct.find(params[:id])
    @serialized_product.destroy

    respond_to do |format|
      format.html { redirect_to(serialized_products_url) }
      format.xml  { head :ok }
    end
  end
end
