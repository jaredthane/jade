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


class PrivilegesController < ApplicationController
  # GET /privileges
  # GET /privileges.xml
  def index
    @privileges = Privilege.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @privileges }
    end
  end

  # GET /privileges/1
  # GET /privileges/1.xml
  def show
    @privilege = Privilege.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @privilege }
    end
  end

  # GET /privileges/new
  # GET /privileges/new.xml
  def new
    @privilege = Privilege.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @privilege }
    end
  end

  # GET /privileges/1/edit
  def edit
    @privilege = Privilege.find(params[:id])
  end

  # POST /privileges
  # POST /privileges.xml
  def create
    @privilege = Privilege.new(params[:privilege])

    respond_to do |format|
      if @privilege.save
        flash[:notice] = 'Privilege was successfully created.'
        format.html { redirect_to(@privilege) }
        format.xml  { render :xml => @privilege, :status => :created, :location => @privilege }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @privilege.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /privileges/1
  # PUT /privileges/1.xml
  def update
    @privilege = Privilege.find(params[:id])

    respond_to do |format|
      if @privilege.update_attributes(params[:privilege])
        flash[:notice] = 'Privilege was successfully updated.'
        format.html { redirect_to(@privilege) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @privilege.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /privileges/1
  # DELETE /privileges/1.xml
  def destroy
    @privilege = Privilege.find(params[:id])
    @privilege.destroy

    respond_to do |format|
      format.html { redirect_to(privileges_url) }
      format.xml  { head :ok }
    end
  end
end
