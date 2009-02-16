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


class WarrantiesController < ApplicationController
  # GET /warranties
  # GET /warranties.xml
  def index
		@warranties = Warranty.search(params[:search], params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @warranties }
    end
  end

  # GET /warranties/1
  # GET /warranties/1.xml
  def show
    @warranty = Warranty.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @warranty }
    end
  end

  # GET /warranties/new
  # GET /warranties/new.xml
  def new
    @warranty = Warranty.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @warranty }
    end
  end

  # GET /warranties/1/edit
  def edit
    @warranty = Warranty.find(params[:id])
  end

  # POST /warranties
  # POST /warranties.xml
  def create
    @warranty = Warranty.new(params[:warranty])

    respond_to do |format|
      if @warranty.save
        flash[:notice] = 'Garantía ha sido creado exitosamente.'
        format.html { redirect_to(warranties_url) }
        format.xml  { render :xml => @warranties, :status => :created, :location => @warranty }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @warranty.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /warranties/1
  # PUT /warranties/1.xml
  def update
    @warranty = Warranty.find(params[:id])

    respond_to do |format|
      if @warranty.update_attributes(params[:warranty])
        flash[:notice] = 'Garantía ha sido actualizado exitosamente.'
        format.html { render :action => "index" }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @warranty.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /warranties/1
  # DELETE /warranties/1.xml
  def destroy
    @warranty = Warranty.find(params[:id])
    @warranty.destroy

    respond_to do |format|
      format.html { redirect_to(warranties_url) }
      format.xml  { head :ok }
    end
  end
end
