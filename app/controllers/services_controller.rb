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


class ServicesController < ApplicationController
	before_filter :login_required
	access_control [:new, :create, :update, :edit, :bulk_edit, :destroy] => '(Gerente | Admin | Compras)' 

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
		if @service.product_type_id==1
			redirect_to product_path(@service)
			return false
		elsif @service.product_type_id==2
			redirect_to discount_path(@service)
			return false
		elsif @service.product_type_id==3
			redirect_to combo_path(@service)
			return false
		end

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
