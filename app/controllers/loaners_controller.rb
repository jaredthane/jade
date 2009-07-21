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



class LoanersController < ApplicationController
  # GET /loaners
  # GET /loaners.xml
  def index
    @loaners = SerializedProduct.find(:all, :conditions=>'is_loaner=true')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @loaners }
    end
  end
	def checkin
    @loaner = SerializedProduct.find(params[:id])

    respond_to do |format|
      if @loaner.update_attributes(params[:loaner])
        flash[:notice] = 'Producto para prestar ha sido actualizado exitosamente.'
        format.html { redirect_to(@loaner) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @loaner.errors, :status => :unprocessable_entity }
      end
    end
  end
  # GET /loaners/1
  # GET /loaners/1.xml
  def show
    @loaner = SerializedProduct.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @loaner }
    end
  end

  # GET /loaners/new
  # GET /loaners/new.xml
  def new_without_serial
    @loaner = SerializedProduct.new(:product_id=params[:product_id])
		@loaner.product.add_to_pool
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @loaner }
    end
  end
  def new_from_serial
    @loaner = SerializedProduct.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @loaner }
    end
  end

  # GET /loaners/1/edit
  def edit
    @loaner = SerializedProduct.find(params[:id])
  end

  # POST /loaners
  # POST /loaners.xml
  def create
    @loaner = SerializedProduct.new(params[:loaner])

    respond_to do |format|
      if @loaner.save
        flash[:notice] = 'Metodo de Pago ha sido creado exitosamente.'
        format.html { redirect_to(@loaner) }
        format.xml  { render :xml => @loaner, :status => :created, :location => @loaner }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @loaner.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /loaners/1
  # PUT /loaners/1.xml
  def update
    @loaner = SerializedProduct.find(params[:id])

    respond_to do |format|
      if @loaner.update_attributes(params[:loaner])
        flash[:notice] = 'Metodo de Pago ha sido actualizado exitosamente.'
        format.html { redirect_to(@loaner) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @loaner.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /loaners/1
  # DELETE /loaners/1.xml
  def destroy
    @loaner = SerializedProduct.find(params[:id])
    @loaner.destroy

    respond_to do |format|
      format.html { redirect_to(loaners_url) }
      format.xml  { head :ok }
    end
  end
end
