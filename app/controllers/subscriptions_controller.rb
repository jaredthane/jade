# Jade Inventory Control System
#Copyright (C) 2009  Jared T. Martin

#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.

#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied subscription of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.

#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.


class SubscriptionsController < ApplicationController
  before_filter :login_required, :only => [ :index, :show, :edit, :update, :destroy, :new, :create ]
	#before_filter {privilege_required('sales')}
	access_control [:new, :create, :update, :edit] => '(Gerente | Admin | Ventas)' 
	access_control [:destroy] => '(Admin)'
  # GET /subscriptions
  # GET /subscriptions.xml
  def index
		@subscriptions = Subscription.search(params[:search], params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @subscriptions }
    end
  end

  # GET /subscriptions/1
  # GET /subscriptions/1.xml
  def show
    @subscription = Subscription.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @subscription }
    end
  end
############################################################################################
# DEPRECATED - DEPRECATED - DEPRECATED - DEPRECATED - DEPRECATED - DEPRECATED - DEPRECATED #
############################################################################################
#  def process_me
#    @subscription = Subscription.find(params[:id])
#		@subscription.process
#    respond_to do |format|
#      format.html { redirect_to(@subscription.client) }
#    end
#  end
  def process_all
  	User.current_user=User.find(1) if !User.current_user
  	list=Subscription.to_process(params[:search])
  	Subscription.process(list)
  	User.current_user=nil if User.current_user.id=1
    respond_to do |format|
      format.html { redirect_to(new_batch_receipts_path) }
      format.xml  { render :xml => @subscription }
    end
  end
  
    
#  def process_client
#  	@client=Entity.find(params[:client_id])
#  
#  	if !current_user.has_rights(['Admin','Gerente','Ventas'])
#			redirect_back_or_default('/products')
#			flash[:error] = "No tiene los derechos suficientes para ver los clientes"
#  	end
#  	list=Subscription.to_process_client(@client)
#  	Subscription.process(list)
#    respond_to do |format|
#      format.html { redirect_to(entity_path(@client)) }
#      format.xml  { render :xml => @client }
#    end
#  end
  def fast_process
  	User.current_user=User.find(1) if !User.current_user
  	list=Subscription.to_process
  	Subscription.fast_process(list)
  	User.current_user=nil if User.current_user.id=1
    respond_to do |format|
      format.html { redirect_to(todays_sales_path) }
      format.xml  { render :xml => @subscription }
    end
  end
  def preview_process
  	@subscriptions=Subscription.to_process(params[:search])
  	@search=params[:search]
		respond_to do |format|
		  format.html { render :layout=>'process'}
		  format.xml  { render :xml => @subscriptions }
		end
  end
############################################################################################
# DEPRECATED - DEPRECATED - DEPRECATED - DEPRECATED - DEPRECATED - DEPRECATED - DEPRECATED #
############################################################################################
#  def create_orders
#    Subscription.first.create_orders
#    respond_to do |format|
#      format.html { redirect_to(subscriptions_results_path) }
#      format.xml  { render :xml => @subscription }
#    end
#  end
#  def preview_orders
#  	@subscriptions = []
#  	cutoff_date=Date.today
#  	cutoff_date=cutoff_date+1 if Date.today.wday==6
#  	for client in Entity.find(:all, :conditions=> '(entity_type_id=2 or entity_type_id=5) AND site_id=' + User.current_user.location_id.to_s)
#			for sub in Subscription.find(:all, :conditions=>'(subscriptions.end_date > CURRENT_DATE OR subscriptions.end_date is null) AND (subscriptions.end_times>1 OR subscriptions.end_times is null) AND (subscriptions.client_id=' + client.id.to_s + ')' )
#			  if sub.last_line
#		      if sub.last_line.received.to_date >> sub.frequency <= cutoff_date
#		      	@subscriptions << sub if !@subscriptions.include?(sub)
#		      end
#		    else
#		    	@subscriptions << sub if !@subscriptions.include?(sub)
#		    end
#			end
#		end
#    respond_to do |format|
#      format.html 
#      format.xml  { render :xml => @subscriptions }
#    end
#  end
#  def show_batch
#		@orders = Order.search_receipt_batch(params[:search], params[:page])
#		@order_type_id	= 1
#		@subscriptions = true
#		respond_to do |format|
#      format.html {render :template=> "/orders/index"}
#      format.xml  { render :xml => @subscriptions }
#    end
#  end
  # GET /subscriptions/new
  # GET /subscriptions/new.xml
  def new
    @subscription = Subscription.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @subscription }
    end
  end

  # GET /subscriptions/1/edit
  def edit
    @subscription = Subscription.find(params[:id])
  end

  # POST /subscriptions
  # POST /subscriptions.xml
  def create
    @subscription = Subscription.new(params[:subscription])

    respond_to do |format|
      if @subscription.save
        flash[:notice] = 'Suscripcion ha sido creado exitosamente.'
        format.html { redirect_to(@subscription) }
        format.xml  { render :xml => @subscriptions, :status => :created, :location => @subscription }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @subscription.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /subscriptions/1
  # PUT /subscriptions/1.xml
  def update
    @subscription = Subscription.find(params[:id])

    respond_to do |format|
      if @subscription.update_attributes(params[:subscription])
        flash[:notice] = 'Suscripcion ha sido actualizado exitosamente.'
        format.html { redirect_to(@subscription) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @subscription.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /subscriptions/1
  # DELETE /subscriptions/1.xml
  def destroy
    @subscription = Subscription.find(params[:id])
    @subscription.destroy

    respond_to do |format|
      format.html { redirect_to(subscriptions_url) }
      format.xml  { head :ok }
    end
  end
end
