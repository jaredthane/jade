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


class RequirementsController < ApplicationController
  # GET /requirements
  # GET /requirements.xml
  def index
    @requirements = Requirement.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @requirements }
    end
  end

  # GET /requirements/1
  # GET /requirements/1.xml
  def show
    @requirement = Requirement.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @requirement }
    end
  end

  # GET /requirements/new
  # GET /requirements/new.xml
  def new
    @requirement = Requirement.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @requirement }
    end
  end
  
  def new
    @requirement = Requirement.new()
    logger.debug "Were ready to save the requirement"
    @requirement.bar_code = params[:requirement][:bar_code]
    @requirement.product_id = params[:requirement][:product_id]
    @requirement.quantity = 1
    logger.debug "Were ready to go back to the client"
    respond_to do |wants|
      wants.html do
        redirect_to '/discounts/' + @requirement.product_id.to_s + '/edit'
      end
      wants.js
    end
  end

  # GET /requirements/1/edit
  def edit
    @requirement = Requirement.find(params[:id])
  end

  # POST /requirements
  # POST /requirements.xml
  def create
   	@requirement = Requirement.create(params[:requirement])
    respond_to do |wants|
      wants.html do
        redirect_to '/discounts/' + @requirement.product_id.to_s + '/edit'
      end
      wants.js
    end
  end

  # PUT /requirements/1
  # PUT /requirements/1.xml
  def update
    @requirement = Requirement.find(params[:id])

    respond_to do |format|
      if @requirement.update_attributes(params[:requirement])
        flash[:notice] = 'Pago ha sido actualizado exitosamente.'
        format.html { redirect_to(@requirement) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @requirement.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /requirements/1
  # DELETE /requirements/1.xml
  def destroy
    @requirement = Requirement.find(params[:id])
    @requirement.destroy

    respond_to do |format|
      format.html { redirect_to(requirements_url) }
      format.xml  { head :ok }
    end
  end
end


