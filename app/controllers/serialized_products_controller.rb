class SerializedProductsController < ApplicationController
  # GET /serialized_products
  # GET /serialized_products.xml
  def index
    @serialized_products = SerializedProduct.search(params[:search], params[:page])

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
