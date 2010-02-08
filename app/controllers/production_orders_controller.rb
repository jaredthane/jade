# Jade Inventory Control System
#Copyright (C) 2009  Jared T. Martin

#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.

#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied account of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.

#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.


class ProductionOrdersController < ApplicationController
	def index
    respond_to do |format|
      format.html do
      	@production_orders = ProductionOrder.search(params[:search], filter = params[:filter], page=(params[:page])||1)
      	if @production_orders.length==1
      		@production_order=@production_orders[0]
      		render :action => 'show'
      		return false
      	end # if condition
      	if params[:filter]=='orders'
      		render :template=>'production_orders/index_orders'
      	elsif params[:filter]=='processes'
      		render :template=>'production_orders/index_processes'
      	else
      		render :template=>'production_orders/index'
      	end
      end
    end
  end

  # GET /requirements/1
  # GET /requirements/1.xml
  def show
    @production_order = ProductionOrder.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @production_order }
    end
  end
  
  def new
    @production_order = ProductionOrder.new(:is_process=>true)
		respond_to do |wants|
			wants.html
			wants.js
		end
  end
    
  def new_line
  	if p=Product.find_by_upc(params[:bar_code])
  		@o=ProductionOrder.new
			if params[:is_output]=='0'
		  	@o.consumption_lines << ConsumptionLine.new(:product=>p, :quantity=>1)
			else
		  	@o.production_lines << ProductionLine.new(:product=>p, :quantity_planned =>1, :quantity=>1)
			end # if params[:]
		end
		
		respond_to do |wants|
			if @o
				wants.html do
					render :layout => false
				end
			else
				wants.html do	
					render :action => 'error', :layout => false
				end
			end
		end
  end
	def new_production
		@process = ProductionOrder.find(params[:id])
		@production_order = @process.new_production_order
    respond_to do |wants|
    	if @production_order.save
    		wants.html do	
 					flash[:notice] = 'Orden de Producion ha sido creado exitosamente.'
    			render :action => 'show'
    		end
    	else
 				flash[:error] = 'No se pudo generar Orden de Producion.'
 				render :action => 'edit'
    	end
    end
	end
	def start_production
		@production_order = ProductionOrder.find(params[:id])
		@production_order.start
		@production_order.save
		respond_to do |wants|
			wants.html do	
 					flash[:notice] = 'Orden de Producion ha sido iniciado exitosamente.'
    			render :action => 'show'
			end
		end
	end
	def finish_production
		@production_order = ProductionOrder.find(params[:id])
		@production_order.finish
		@production_order.save
		respond_to do |wants|
			wants.html do	
 					flash[:notice] = 'Orden de Producion ha sido terminado exitosamente.'
    			render :action => 'show'
			end
		end
	end
  # GET /requirements/1/edit
  def edit
    @production_order = ProductionOrder.find(params[:id])
    @obj=@production_order
  end

  # POST /requirements
  # POST /requirements.xml
  def create
  	params[:production_order][:created_at]=untranslate_month(params[:production_order][:created_at]) if params[:production_order][:created_at]
   	params[:production_order][:started_at]=untranslate_month(params[:production_order][:started_at]) if params[:production_order][:started_at]
   	params[:production_order][:finished_at]=untranslate_month(params[:production_order][:finished_at]) if params[:production_order][:finished_at]
   	@production_order = ProductionOrder.new(params[:production_order])
   	@production_order.site=User.current_user.location
   	@production_order.created_by=User.current_user
    respond_to do |wants|
    	if @production_order.valid?
		    wants.html do
		    	@production_order.save
	 				flash[:notice] = 'Proceso de Producion ha sido creado exitosamente.'
		      render :action => 'show'
		    end
		  else
		  	wants.html do
	 				flash[:error] = 'No se pudo crear Proceso de Producion.'
		      render :action => 'edit'
		    end
		  end
    end
  end

  # PUT /requirements/1
  # PUT /requirements/1.xml
  def update
    params[:production_order][:created_at]=untranslate_month(params[:production_order][:created_at]) if params[:production_order][:created_at]
   	params[:production_order][:started_at]=untranslate_month(params[:production_order][:started_at]) if params[:production_order][:started_at]
   	params[:production_order][:finished_at]=untranslate_month(params[:production_order][:finished_at]) if params[:production_order][:finished_at]
   	@production_order = ProductionOrder.find(params[:id])

    respond_to do |format|
      if @production_order.update_attributes(params[:production_order])
        flash[:notice] = 'Pago ha sido actualizado exitosamente.'
        format.html { redirect_to(@production_order) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @production_order.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /requirements/1
  # DELETE /requirements/1.xml
  def destroy
    @production_order = ProductionOrder.find(params[:id])
    @production_order.destroy

    respond_to do |format|
      format.html { redirect_to(production_orders_url) }
      format.xml  { head :ok }
    end
  end
end
