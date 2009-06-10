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
class EntitiesController < ApplicationController
	before_filter :login_required
	access_control [:new, :create, :update, :edit, :destroy] => '(gerente | admin | ventas | compras | inventario)' 
	def allowed(entity_type)
		case (entity_type)
		  when 'sites'
		  	if !current_user.has_rights(['admin','compras','gerente','ventas','inventario','invitado'])
					redirect_back_or_default('/products')
					flash[:error] = "No tiene los derechos suficientes para ver los sitios"
		  	end
		  when 'clients'
		  	if !current_user.has_rights(['admin','gerente','ventas'])
					redirect_back_or_default('/products')
					flash[:error] = "No tiene los derechos suficientes para ver los clientes"
		  	end
		  when 'vendors'
		  	if !current_user.has_rights(['admin','compras','gerente'])
					redirect_back_or_default('/products')
					flash[:error] = "No tiene los derechos suficientes para ver los proveedores"
		  	end
		  when 1
		  	if !current_user.has_rights(['admin','compras','gerente'])
					redirect_back_or_default('/products')
					flash[:error] = "No tiene los derechos suficientes para ver los proveedores"
		  	end
		  when 2
		  	if !current_user.has_rights(['admin','gerente','ventas'])
					redirect_back_or_default('/products')
					flash[:error] = "No tiene los derechos suficientes para ver los clientes"
		  	end
		  when 3
		  	if !current_user.has_rights(['admin','compras','gerente','ventas','inventario','invitado'])
					redirect_back_or_default('/products')
					flash[:error] = "No tiene los derechos suficientes para ver los sitios"
		  	end
		  when 5
		  	if !current_user.has_rights(['admin','gerente','ventas'])
					redirect_back_or_default('/products')
					flash[:error] = "No tiene los derechos suficientes para ver los clientes"
		  	end
    end  
    return true  
	end
	def my_clients
    return false if !allowed('clients')
    @search = (params[:search]||'') + (params[:filter]||'')
    @filters = params[:filter]||''
    @search += ' tipo:clientes asesor:'+ User.current_user.id.to_s
#    puts "entity type = " + @entity_type
    @entities = Entity.search(@search, params[:page])
    if @entities.length == 1
			@entity=@entities[0]
			render :action => 'show'
			return false
		end
    respond_to do |format|
      format.html { render :action => 'index' }
      format.xml  { render :xml => @entities }
      format.js
    end
	end
	##################################################################################################
	# Processes subscriptions for all clients in current view and redirects to todays orders
	#################################################################################################
	def process_subscriptions
    return false if !allowed('clients')
    search = (params[:search]||'') + " activo:si tipo:clientes"
    logger.debug "my search->"+ search
  	@clients = Entity.search_without_pagination(search)
  	logger.debug @clients.inspect
  	for client in @clients
  		client.process_subscriptions()
  	end
    respond_to do |format|
      format.html { redirect_to(todays_sales_path) }
      format.xml  { render :xml => @subscription }
    end
  end
  ##################################################################################################
  # Displays end users assigned to user
  #################################################################################################
	def my_end_users
		@user_id = User.current_user.id
		@entity_type = 'end_users'
    @search = (params[:search]||'')
    @search += ' tipo:consumidor asesor:'+ User.current_user.id.to_s
    return false if !allowed('clients')
#    puts "entity type = " + @entity_type
    @entities = Entity.search(params[:search], params[:page])
    if @entities.length == 1
			@entity=@entities[0]
			render :action => 'show'
			return false
		end
    respond_to do |format|
      format.html { render :action => 'index' }
      format.xml  { render :xml => @entities }
      format.js
    end
	end
############################################################################################
# DEPRECATED - DEPRECATED - DEPRECATED - DEPRECATED - DEPRECATED - DEPRECATED - DEPRECATED #
############################################################################################
#	def process_subscriptions
#		return false if !allowed('clients')
#    search = (params[:search]||'') + "activo:si tipo:clientes"
#    @entities = Entity.search_without_pagination(search)
#    for entity in @entities
#    	entity.process_subscriptions
#    end
#    respond_to do |format|
#      format.html {
#		    if @entities.length == 1
#					@entity=@entities[0]
#					redirect_to(entity_url(@entity.id))
#					return false
#				end
#       }
#      format.xml  { render :xml => @entities }
#      format.js {logger.debug "Should be here" }
#    end
#	
#	end
def new_history
  @entity = Entity.find(params[:id])
  return false if !allowed('clients')
  respond_to do |format|
    format.html # new.html.erb
    format.xml  { render :xml => @entity }
  end
end
def create_history
  @entity = Entity.find(params[:id])
  months=(params[:number].to_i||0)
  logger.debug 'months='+months.to_s
  sub=Subscription.find_by_client_id(@entity.id)
  for i in 1..months
  	logger.debug "doing round:"+i.to_s
  	d=Date.new(2009, 6, @entity.subscription_day) << months-i+1
  	o=Order.create(:received => d, :created_at=>d, :vendor => sub.vendor, :client => sub.client,:user => User.current_user, :order_type_id => 1, :last_batch =>true)
	  sub.process(o, d)
  	logger.info "created history id:"+o.id.to_s
	end
	@entity_type = @entity.entity_type_id
	return if !allowed(@entity.entity_type_id || 'entities')
	if @entity_type == 3
		current_user.location_id = params[:id]
		current_user.save
	end
	if @entity.entity_type_id == 2 or @entity.entity_type_id == 5
	  @subs=Subscription.find(:all, 
                            :conditions => ['client_id=:clientid AND (end_times>0 or end_times is null) and (end_date>now() or end_date is null)', {:clientid => @entity.id.to_s}],
                            :limit => 10, 
                            :order => 'created_at DESC')
    @subs=nil if @subs.length==0
		current_user.price_group_name_id = @entity.price_group_name_id
		current_user.save
		logger.debug "setting price group id"
		current_user.price_group_name_id = @entity.price_group_name_id
		current_user.save
		logger.debug "current_user.price_group_name_id=#{current_user.price_group_name_id.to_s}"
	end
  respond_to do |format|
    format.html { render :action => 'show' }
    format.xml  { render :xml => @entity }
  end
end
	def my_credito_fiscal
		@user_id = User.current_user.id
		@entity_type = 'wholesale_clients'
    return false if !allowed('clients')
#    puts "entity type = " + @entity_type
    @search = (params[:search]||'')
    @search += ' tipo:credito asesor:'+ User.current_user.id.to_s
    @entities = Entity.search(@search, params[:page])
    if @entities.length == 1
			@entity=@entities[0]
			render :action => 'show'
			return false
		end
    respond_to do |format|
      format.html { render :action => 'index' }
      format.xml  { render :xml => @entities }
      format.js
    end
	end
  # GET /entities
  # GET /entities.xml
  def index
    case params[:filter]
    when ' tipo:cliente'
    	@entity_type = 'clients'
    when ' tipo:client'
    	@entity_type = 'clients'
    when ' tipo:vendor'
    	@entity_type = 'vendors'
    when ' tipo:consumidor'
    	@entity_type = 'end_users'
    when ' tipo:credito'
    	@entity_type = 'wholesale_clients'
    when ' tipo:site'
    	@entity_type = 'sites'  
    else
    	@entity_type = 'entities'  
    end
    return false if !allowed((params[:entity_type] || 'entities'))
    search = (params[:search]||'') + (params[:filter]||'')
    search += ' tipo:' + @entity_type if @entity_type != 'all'
    @entities = Entity.search(search, params[:page])
    respond_to do |format|
      format.html {
		    if @entities.length == 1
					@entity=@entities[0]
					redirect_to(entity_url(:id=>@entity.id, :search=>params[:search]))
					return false
				end
       }
      format.xml  { render :xml => @entities }
      format.js {logger.debug "Should be here" }
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
		return if !allowed(@entity.entity_type_id || 'entities')
		if @entity_type == 3
			current_user.location_id = params[:id]
			current_user.save
		end
		logger.debug "@entity.entity_type_id=#{@entity.entity_type_id.to_s}"
		if @entity.entity_type_id == 2 or @entity.entity_type_id == 5
		  @subs=Subscription.find(:all, 
                              :conditions => ['client_id=:clientid AND (end_times>0 or end_times is null) and (end_date>now() or end_date is null)', {:clientid => @entity.id.to_s}],
                              :limit => 10, 
                              :order => 'created_at DESC')
      @subs=nil if @subs.length==0
      @unpaid = @entity.unpaid_orders
      @unpaid=nil if @unpaid.length==0
			current_user.price_group_name_id = @entity.price_group_name_id
			current_user.save
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
    	@entity.site_id = User.current_user.location_id
    when 'entities'
    	@entity = Entity.new()
    end    
    @entity.user=current_user
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
      	logger.debug "creating entity workd"
      	logger.debug "|" + params[:entity][:entity_type_id].to_s + "|"
      	if params[:entity][:entity_type_id] == '3'
      	    logger.debug "its a site"
		    	for p in Product.all
		    		i=Inventory.create(:entity=>@entity, :product=>p, :quantity=>0, :min=>0, :max=>0, :to_order=>0)
		    	end  
		    	logger.debug "made the inventories"
            	for pgn in PriceGroupName.all
                    pg=PriceGroup.create(:price_group_name=>pgn, :entity=>@entity)
                end  
                logger.debug " made the price groups"
		    end    	
        flash[:notice] = 'Entidad ha sido creado exitosamente.'
        format.html { redirect_to(@entity) }
        format.xml  { render :xml => @entity, :status => :created, :location => @entity }
      else
      	logger.debug "creating entity didnt workd"
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
        logger.debug "entity_type="+ @entity.entity_type_id.to_s
        logger.debug "entity_type="+ Entity.find(@entity.id).entity_type_id.to_s
        
        flash[:notice] = 'Entidad  ha sido actualizado exitosamente.'
        format.html { redirect_to(@entity) }
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
