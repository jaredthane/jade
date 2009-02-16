class EntityTypesController < ApplicationController
	before_filter :login_required
	access_control [:new, :create, :update, :edit, :destroy] => '(admin)' 
  # GET /entity_types
  # GET /entity_types.xml
  def index
    @entity_types = EntityType.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @entity_types }
    end
  end

  # GET /entity_types/1
  # GET /entity_types/1.xml
  def show
    @entity_type = EntityType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @entity_type }
    end
  end

  # GET /entity_types/new
  # GET /entity_types/new.xml
  def new
    @entity_type = EntityType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @entity_type }
    end
  end

  # GET /entity_types/1/edit
  def edit
    @entity_type = EntityType.find(params[:id])
  end

  # POST /entity_types
  # POST /entity_types.xml
  def create
    @entity_type = EntityType.new(params[:entity_type])

    respond_to do |format|
      if @entity_type.save
        flash[:notice] = 'EntityType was successfully created.'
        format.html { redirect_to(@entity_type) }
        format.xml  { render :xml => @entity_type, :status => :created, :location => @entity_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @entity_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /entity_types/1
  # PUT /entity_types/1.xml
  def update
    @entity_type = EntityType.find(params[:id])

    respond_to do |format|
      if @entity_type.update_attributes(params[:entity_type])
        flash[:notice] = 'EntityType was successfully updated.'
        format.html { redirect_to(@entity_type) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @entity_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /entity_types/1
  # DELETE /entity_types/1.xml
  def destroy
    @entity_type = EntityType.find(params[:id])
    @entity_type.destroy

    respond_to do |format|
      format.html { redirect_to(entity_types_url) }
      format.xml  { head :ok }
    end
  end
end
