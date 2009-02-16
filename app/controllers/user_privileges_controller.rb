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


class UserPrivilegesController < ApplicationController
  # GET /user_privileges
  # GET /user_privileges.xml
  def index
    @user_privileges = UserPrivilege.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @user_privileges }
    end
  end

  # GET /user_privileges/1
  # GET /user_privileges/1.xml
  def show
    @user_privilege = UserPrivilege.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user_privilege }
    end
  end

  # GET /user_privileges/new
  # GET /user_privileges/new.xml
  def new
    @user_privilege = UserPrivilege.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user_privilege }
    end
  end

  # GET /user_privileges/1/edit
  def edit
    @user_privilege = UserPrivilege.find(params[:id])
  end

  # POST /user_privileges
  # POST /user_privileges.xml
  def create
    @user_privilege = UserPrivilege.new(params[:user_privilege])

    respond_to do |format|
      if @user_privilege.save
        flash[:notice] = 'UserPrivilege was successfully created.'
        format.html { redirect_to(@user_privilege) }
        format.xml  { render :xml => @user_privilege, :status => :created, :location => @user_privilege }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user_privilege.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /user_privileges/1
  # PUT /user_privileges/1.xml
  def update
    @user_privilege = UserPrivilege.find(params[:id])

    respond_to do |format|
      if @user_privilege.update_attributes(params[:user_privilege])
        flash[:notice] = 'UserPrivilege was successfully updated.'
        format.html { redirect_to(@user_privilege) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user_privilege.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /user_privileges/1
  # DELETE /user_privileges/1.xml
  def destroy
    @user_privilege = UserPrivilege.find(params[:id])
    @user_privilege.destroy

    respond_to do |format|
      format.html { redirect_to(user_privileges_url) }
      format.xml  { head :ok }
    end
  end
end
