class EntitiesController < ApplicationController
	before_filter :login_required
	access_control [:new, :create, :update, :edit, :destroy] => '(gerente | admin | ventas | compras)' 
	
  # GET /entities
  # GET /entities.xml
  def index
    @entity_type = params[:entity_type] || 'all'
    puts "entity type = " + @entity_type
    @entities = Entity.search(params[:search], params[:page], @entity_type)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @entities }
      format.js
    end
  end
  # GET /entities
  # GET /entities.xml
  def birthdays
    @entities = Entity.search_birthdays(params[:search])
    respond_to do |format|
      format.html { render :action => "birthdays" }
      format.xml  { render :xml => @entities }
      format.js
    end
  end
  # GET /entities/1
  # GET /entities/1.xml
  def show
    @entity = Entity.find(params[:id])
		@entity_type = @entity.entity_type_id
		if @entity_type == 3
			current_user.location_id = params[:id]
			current_user.save
		end
		logger.debug "@entity_type=#{@entity_type.to_s}"
		if @entity_type == 2 or @entity_type == 5
			logger.debug "setting price group id"
			current_user.price_group_name_id = @entity.price_group_name_id
			current_user.save
			logger.debug "current_user.price_group_name_id=#{current_user.price_group_name_id.to_s}"
		end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @entity }
    end
  end
  # GET /entities/1/movements
  # GET /entities/1/movements.xml
  def movements
    @entity = Entity.find(params[:id])
		@entity_type = @entity.entity_type_id
		if @entity_type == 3
			current_user.location_id = params[:id]
			current_user.save
		end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @entity }
    end
  end
  
  # GET /entities/1/products
  # GET /entities/1/products.xml
  def products
    @entity = Entity.find(params[:id])
		@entity_type = @entity.entity_type_id
		if @entity_type == 3
			current_user.location_id = params[:id]
			current_user.save
		end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @entity }
    end
  end

  # GET /entities/new
  # GET /entities/new.xml
  def new
  	case (params[:entity_type] || 'entities')
    when 'sites'
    	@entity = Entity.new(:entity_type_id=> 3)
    when 'vendors'
    	@entity = Entity.new(:entity_type_id=> 1)    	
    when 'clients'
    	@entity = Entity.new(:entity_type_id=> 2)
    when 'entities'
    	@entity = Entity.new()
    end    
		@entity_type=params[:entity_type]
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @entity }
    end
  end

  # GET /entities/1/edit
  def edit
    @entity = Entity.find(params[:id])
  end

  # POST /entities
  # POST /entities.xml
  def create
    @entity = Entity.new(params[:entity])

    respond_to do |format|
      if @entity.save
      	puts "creating entity workd"
        flash[:notice] = 'Entidad ha sido creado exitosamente.'
        format.html { redirect_to(entities_url) }
        format.xml  { render :xml => @entity, :status => :created, :location => @entity }
      else
      	puts "creating entity didnt workd"
        format.html { render :action => "new" }
        format.xml  { render :xml => @entity.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /entities/1
  # PUT /entities/1.xml
  def update
    @entity = Entity.find(params[:id])

    respond_to do |format|
      if @entity.update_attributes(params[:entity])
        flash[:notice] = 'Entidad  ha sido actualizado exitosamente.'
        format.html { redirect_to(entities_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @entity.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /entities/1
  # DELETE /entities/1.xml
  def destroy
    @entity = Entity.find(params[:id])
    @entity.destroy

    respond_to do |format|
      format.html { redirect_to(entities_url) }
      format.xml  { head :ok }
    end
  end
end
