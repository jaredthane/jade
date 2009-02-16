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
class InventoriesController < ApplicationController
  # GET /inventories
  # GET /inventories.xml
  def index
		@inventories = Inventory.search(params[:search], params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @inventories }
    end
  end

  # GET /inventories/1
  # GET /inventories/1.xml
  def show
    @inventory = Inventory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @inventory }
    end
  end

  # GET /inventories/new
  # GET /inventories/new.xml
  def new
    @inventory = Inventory.new
    @inventory.order_id = params[:order_id]
		@inventory.inventory_method_id = 1
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @inventory }
    end
  end

  # GET /inventories/1/edit
  def edit
    @inventory = Inventory.find(params[:id])
  end

  # POST /inventories
  # POST /inventories.xml
  def create
    @inventory = Inventory.new(params[:inventory])

    respond_to do |format|
      if @inventory.save
        flash[:notice] = 'Pago ha sido creado exitosamente.'
        format.html { redirect_to(@inventory.order) }
        format.xml  { render :xml => @inventory, :status => :created, :location => @inventory }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @inventory.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /inventories/1
  # PUT /inventories/1.xml
  def update
    @inventory = Inventory.find(params[:id])

    respond_to do |format|
      if @inventory.update_attributes(params[:inventory])
        flash[:notice] = 'Pago ha sido actualizado exitosamente.'
        format.html { redirect_to(@inventory.order) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @inventory.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /inventories/1
  # DELETE /inventories/1.xml
  def destroy
    @inventory = Inventory.find(params[:id])
    @inventory.destroy

    respond_to do |format|
      format.html { redirect_to(inventories_url) }
      format.xml  { head :ok }
    end
  end
end
