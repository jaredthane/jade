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
class MovementTypesController < ApplicationController
  # GET /movement_types
  # GET /movement_types.xml
  def index
    @movement_types = MovementType.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @movement_types }
    end
  end

  # GET /movement_types/1
  # GET /movement_types/1.xml
  def show
    @movement_type = MovementType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @movement_type }
    end
  end

  # GET /movement_types/new
  # GET /movement_types/new.xml
  def new
    @movement_type = MovementType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @movement_type }
    end
  end

  # GET /movement_types/1/edit
  def edit
    @movement_type = MovementType.find(params[:id])
  end

  # POST /movement_types
  # POST /movement_types.xml
  def create
    @movement_type = MovementType.new(params[:movement_type])

    respond_to do |format|
      if @movement_type.save
        flash[:notice] = 'MovementType was successfully created.'
        format.html { redirect_to(@movement_type) }
        format.xml  { render :xml => @movement_type, :status => :created, :location => @movement_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @movement_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /movement_types/1
  # PUT /movement_types/1.xml
  def update
    @movement_type = MovementType.find(params[:id])

    respond_to do |format|
      if @movement_type.update_attributes(params[:movement_type])
        flash[:notice] = 'MovementType was successfully updated.'
        format.html { redirect_to(@movement_type) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @movement_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /movement_types/1
  # DELETE /movement_types/1.xml
  def destroy
    @movement_type = MovementType.find(params[:id])
    @movement_type.destroy

    respond_to do |format|
      format.html { redirect_to(movement_types_url) }
      format.xml  { head :ok }
    end
  end
end
