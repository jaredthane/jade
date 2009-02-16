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
