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


class PhysicalCountsController < ApplicationController
	def index
		@counts = Order.search_physical_counts(params[:search], params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @count }
    end
  end
  def show
    @count = Order.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @count }
    end
  end
  def new
    @count = Order.new(:order_type_id => 5)
    @count.user = current_user
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @count }
    end
  end
  def edit
    @count = Order.find(params[:id])
  end
  def create
    @count = Order.new(params[:count])
    respond_to do |format|
      if @count.save
        flash[:notice] = 'Cuenta Fisica ha sido creado exitosamente.'
        format.html { redirect_to(@count.order) }
        format.xml  { render :xml => @count, :status => :created }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @count.errors, :status => :unprocessable_entity }
      end
    end
  end
  def update
    @count = Order.find(params[:id])

    respond_to do |format|
      if @count.update_attributes(params[:count])
        flash[:notice] = 'Pago ha sido actualizado exitosamente.'
        format.html { redirect_to(@count.order) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @count.errors, :status => :unprocessable_entity }
      end
    end
  end
  def destroy
    @count = Order.find(params[:id])
    @count.destroy

    respond_to do |format|
      format.html { redirect_to(physical_counts_url) }
      format.xml  { head :ok }
    end
  end
  def submit
    @count = Order.find(params[:id])

    respond_to do |format|
      if @count.update_attributes(params[:count])
        flash[:notice] = 'Pago ha sido actualizado exitosamente.'
        format.html { redirect_to(@count.order) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @count.errors, :status => :unprocessable_entity }
      end
    end
  end
end
