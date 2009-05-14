# Jade Inventory Control System
#Copyright (C) 2009  Jared T. Martin

#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.

#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied trans of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.

#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.


class TransController < ApplicationController
  # GET /trans
  # GET /trans.xml
#  def index
#		@trans = Trans.search(params[:search], params[:page])
#    respond_to do |format|
#      format.html # index.html.erb
#      format.xml  { render :xml => @trans }
#    end
#  end

  # GET /trans/1
  # GET /trans/1.xml
  def show
    @trans = Trans.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @trans }
    end
  end

  # GET /trans/new
  # GET /trans/new.xml
  def new
    @accounts ={} 
    for a in Account.find(:all, :conditions=> 'postable = True')
      @accounts[a.number.to_s+' '+a.name]=a.id
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @trans }
    end
  end

  # POST /trans
  # POST /trans.xml
  def create
    @trans = Trans.new(params[:trans])

    respond_to do |format|
      if @trans.save
        flash[:notice] = 'Garantía ha sido creado exitosamente.'
        format.html { redirect_to(trans_url) }
        format.xml  { render :xml => @trans, :status => :created, :location => @trans }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @trans.errors, :status => :unprocessable_entity }
      end
    end
  end
end
