class RequirementsController < ApplicationController
  # GET /requirements
  # GET /requirements.xml
  def index
    @requirements = Requirement.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @requirements }
    end
  end

  # GET /requirements/1
  # GET /requirements/1.xml
  def show
    @requirement = Requirement.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @requirement }
    end
  end

  # GET /requirements/new
  # GET /requirements/new.xml
  def new
    @requirement = Requirement.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @requirement }
    end
  end
  
  def new
    @requirement = Requirement.new()
    @requirement.bar_code = params[:requirement][:bar_code]
    @requirement.product_id = params[:requirement][:product_id]
    @requirement.quantity = 1
    respond_to do |wants|
      wants.html do
        redirect_to '/discounts/' + @requirement.product_id.to_s + '/edit'
      end
      wants.js
    end
  end

  # GET /requirements/1/edit
  def edit
    @requirement = Requirement.find(params[:id])
  end

  # POST /requirements
  # POST /requirements.xml
  def create
   	@requirement = Requirement.create(params[:requirement])
    respond_to do |wants|
      wants.html do
        redirect_to '/discounts/' + @requirement.product_id.to_s + '/edit'
      end
      wants.js
    end
  end

  # PUT /requirements/1
  # PUT /requirements/1.xml
  def update
    @requirement = Requirement.find(params[:id])

    respond_to do |format|
      if @requirement.update_attributes(params[:requirement])
        flash[:notice] = 'Pago ha sido actualizado exitosamente.'
        format.html { redirect_to(@requirement) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @requirement.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /requirements/1
  # DELETE /requirements/1.xml
  def destroy
    @requirement = Requirement.find(params[:id])
    @requirement.destroy

    respond_to do |format|
      format.html { redirect_to(requirements_url) }
      format.xml  { head :ok }
    end
  end
end


