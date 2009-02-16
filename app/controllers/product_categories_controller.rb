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


class ProductCategoriesController < ApplicationController
  def index
		@product_categories = ProductCategory.search(params[:search], params[:page])
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
  def destroy
  	@product_category = ProductCategory.find(params[:id])
   	@product_category.destroy

    respond_to do |format|
      format.html { redirect_to(products_url) }
      format.xml  { head :ok }
    end
  end
end
