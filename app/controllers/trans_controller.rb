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
  def index
		@trans = Trans.search(params[:search], (params[:page]||1))
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @trans }
    end
  end 
  # GET /trans/1
  # GET /trans/1.xml
  def show
  	return false if !check_user(User::VIEW_TRANSACTIONS,'No tiene los derechos suficientes para ver transacciones')
    @trans = Trans.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.pdf # show.html.erb
      format.xml  { render :xml => @trans }
    end
  end

  # GET /trans/new
  # GET /trans/new.xml
  def new
  	return false if !check_user(User::CREATE_TRANSACTIONS,'No tiene los derechos suficientes para crear transacciones')
    @accounts ={} 
    for a in Account.find(:all)
      @accounts[a.number.to_s+' '+a.name]=a.id
    end
		@trans = Trans.new(:created_at=>User.current_user.today)
		@credit = Post.new(:post_type_id=>1, :trans=>@trans)
		@debit = Post.new(:post_type_id=>1, :trans=>@trans)
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @trans }
    end
  end
  
  def edit
  	return false if !check_user(User::CHANGE_TRANSACTIONS,'No tiene los derechos suficientes para cambiar transacciones')

    @trans = Trans.find(params[:id])
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @trans }
    end
  end
  def update
  	return false if !check_user(User::CHANGE_TRANSACTIONS,'No tiene los derechos suficientes para cambiar transacciones')
  	debugger
    @trans = Trans.find(params[:id])

    respond_to do |format|
      if @trans.update_attributes(params[:trans])
        flash[:notice] = 'Transaccion ha sido actualizado exitosamente.'
        format.html { redirect_to(tran_path(@trans)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @trans.errors, :status => :unprocessable_entity }
      end
    end
  end
  # GET /posts/new
  # GET /posts/new.xml
  def new_post
  	return false if !check_user(User::CREATE_TRANSACTIONS,'No tiene los derechos suficientes para crear transacciones')
  	@post=Post.new(:trans=>params[:trans_id])
    @accounts ={} 
    for a in Account.find(:all, :conditions=> 'postable = True')
      @accounts[a.number.to_s+' '+a.name]=a.id
    end
    respond_to do |format|
      format.html # new.html.erb
      format.js # new.html.erb
      format.xml  { render :xml => @trans }
    end
  end
  # POST /trans
  # POST /trans.xml
  def create
  	return false if !check_user(User::CREATE_TRANSACTIONS,'No tiene los derechos suficientes para crear transacciones')
    @trans = Trans.new(params[:trans])
    @trans.created_at=User.current_user.today
		@trans.add_posts(params[:new_posts])
    respond_to do |format|
      if @trans.save
        flash[:notice] = 'Garantía ha sido creado exitosamente.'
        format.html { redirect_to(accounts_url) }
        format.xml  { render :xml => @trans, :status => :created, :location => @trans }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @trans.errors, :status => :unprocessable_entity }
      end
    end
  end
  def destroy
  	return false if !check_user(User::DELETE_TRANSACTIONS,'No tiene los derechos suficientes para borrar transacciones')
    t = Trans.find(params[:id])
    t.destroy

    respond_to do |format|
      format.html { redirect_to(trans_url) }
      format.xml  { head :ok }
    end
  end
end
