class ServicesController < ApplicationController
	before_filter :login_required
	access_control [:new, :create, :update, :edit, :bulk_edit, :destroy] => '(gerente | admin | compras)' 

  def index
    @services = Product.search_for_services(params[:search], params[:page])
		
    respond_to do |format|
      format.html # index.html.erb
      format.xml
      format.js
    end
  end

  # GET /services/1
  # GET /services/1.xml
  def show
    @service = Product.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @service }
    end
  end

  # GET /services/new
  # GET /services/new.xml
  def new
    @service = Product.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @service }
    end
  end

  # GET /services/1/edit
  def edit
    @service = Product.find(params[:id])
  end

  # POST /services
  # POST /services.xml
  def create
    @service = Product.new(params[:service])
    for e in Entity.find_all_by_entity_type_id(3)
    	i=Inventory.new(:entity=>e, :service=>@service, :quantity=>0, :min=>0, :max=>0, :to_order=>0)
    	i.save
    end
    respond_to do |format|
      if @service.save
      	@service.update_attributes(params[:service])
        flash[:notice] = 'Servicio ha sido creado exitosamente.'
        format.html { redirect_to(@service) }
        format.xml  { render :xml => @service, :status => :created, :location => @service }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @service.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /services/1
  # DELETE /services/1.xml
  def destroy
    @service = Product.find(params[:id])
    @service.destroy

    respond_to do |format|
      format.html { redirect_to(services_url) }
      format.xml  { head :ok }
    end
  end
end
