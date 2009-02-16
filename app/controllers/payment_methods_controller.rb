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



class PaymentMethodsController < ApplicationController
  # GET /payment_methods
  # GET /payment_methods.xml
  def index
    @payment_methods = PaymentMethod.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @payment_methods }
    end
  end

  # GET /payment_methods/1
  # GET /payment_methods/1.xml
  def show
    @payment_method = PaymentMethod.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @payment_method }
    end
  end

  # GET /payment_methods/new
  # GET /payment_methods/new.xml
  def new
    @payment_method = PaymentMethod.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @payment_method }
    end
  end

  # GET /payment_methods/1/edit
  def edit
    @payment_method = PaymentMethod.find(params[:id])
  end

  # POST /payment_methods
  # POST /payment_methods.xml
  def create
    @payment_method = PaymentMethod.new(params[:payment_method])

    respond_to do |format|
      if @payment_method.save
        flash[:notice] = 'Metodo de Pago ha sido creado exitosamente.'
        format.html { redirect_to(@payment_method) }
        format.xml  { render :xml => @payment_method, :status => :created, :location => @payment_method }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @payment_method.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /payment_methods/1
  # PUT /payment_methods/1.xml
  def update
    @payment_method = PaymentMethod.find(params[:id])

    respond_to do |format|
      if @payment_method.update_attributes(params[:payment_method])
        flash[:notice] = 'Metodo de Pago ha sido actualizado exitosamente.'
        format.html { redirect_to(@payment_method) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @payment_method.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /payment_methods/1
  # DELETE /payment_methods/1.xml
  def destroy
    @payment_method = PaymentMethod.find(params[:id])
    @payment_method.destroy

    respond_to do |format|
      format.html { redirect_to(payment_methods_url) }
      format.xml  { head :ok }
    end
  end
end
