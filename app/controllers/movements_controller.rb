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
class MovementsController < ApplicationController
	before_filter :login_required
	access_control [:new, :create, :update, :edit, :destroy] => '(Admin)' 
  # GET /movements
  # GET /movements.xml
  def for_product
    @movements = Movement.for_product_in_site(params[:id], params[:page], params[:site])
    respond_to do |format|
      format.html {render :template=> "/movements/index"}
      format.xml  { render :xml => @movements }
    end
  end
  def index
    #@movements = Movement.find(:all)
	@movements = Movement.search(params[:search], params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @movements }
    end
  end

  # GET /movements/1
  # GET /movements/1.xml
  def show
    @movement = Movement.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @movement }
    end
  end

  # GET /movements/new
  # GET /movements/new.xml
  def new
    @movement = Movement.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @movement }
    end
  end

  # GET /movements/1/edit
  def edit
    @movement = Movement.find(params[:id])
  end

  # POST /movements
  # POST /movements.xml
  def create
    @movement = Movement.new(params[:movement])
		$audit.info "Creating movement"
    respond_to do |format|
      if @movement.save
        flash[:notice] = 'Movement was successfully created.'
        format.html { redirect_to(@movement) }
        format.xml  { render :xml => @movement, :status => :created, :location => @movement }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @movement.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /movements/1
  # PUT /movements/1.xml
  def update
    @movement = Movement.find(params[:id])

    respond_to do |format|
      if @movement.update_attributes(params[:movement])
        flash[:notice] = 'Movement was successfully updated.'
        format.html { redirect_to(@movement) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @movement.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /movements/1
  # DELETE /movements/1.xml
  def destroy
    @movement = Movement.find(params[:id])
    @movement.destroy

    respond_to do |format|
      format.html { redirect_to(movements_url) }
      format.xml  { head :ok }
    end
  end
end
