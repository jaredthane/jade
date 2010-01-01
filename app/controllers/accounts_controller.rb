# Jade Inventory Control System
#Copyright (C) 2009  Jared T. Martin

#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.

#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied account of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.

#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.


class AccountsController < ApplicationController
  before_filter :login_required
	#before_filter {privilege_required('sales')}
  # GET /accounts
  # GET /accounts.xml
  def index
#  	logger.debug "!check_user(User::VIEW_ACCOUNTS,'No tiene los derechos suficientes para ver las cuentas')=#{!check_user(User::VIEW_ACCOUNTS,'No tiene los derechos suficientes para ver las cuentas').to_s}"
  	return false if !check_user(User::VIEW_ACCOUNTS,'No tiene los derechos suficientes para ver las cuentas')
 		search=((params[:search]||'') + ' ' + (params[:q]||'') ).strip
		@accounts = Account.search(search, params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.js
    end
  end

  # GET /accounts/1
  # GET /accounts/1.xml
  def show
  	return false if !check_user(User::VIEW_ACCOUNTS,'No tiene los derechos suficientes para ver las cuentas')
    @account = Account.find(params[:id])
		@myposts = @account.recent_posts(20)

    respond_to do |format|
      format.html # show.html.erb
      format.pdf
      format.xml  { render :xml => @account }
    end
  end
	def new_balance_transfer
		return false if !check_user(User::CREATE_TRANSACTIONS,'No tiene los derechos suficientes para hacer transferencias de saldo')
    @account = Account.find(params[:id])
    if @account.posts.last
			@amt = @account.posts.last.balance
			
		else
			@amt = 0
		end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @account }
    end		
	end
	def create_balance_transfer
		return false if !check_user(User::CREATE_TRANSACTIONS,'No tiene los derechos suficientes para hacer transferencias de saldo')
		account = Account.find(params[:id])
		other=Account.find(params[:number].to_i)
		if !account.posts.last
			flash[:error] = "La cuenta no tiene ningun saldo para trasferir."
			redirect_to account
			return false
		end
    flash[:info] = "El saldo se ha transferido existosamente" if account.transfer_balance_to(other)
    redirect_to account
    return false
	end
	def recount	
		account = Account.find(params[:id])
		account.recount_balances
		redirect_to account
		return false
	end
  # GET /accounts/new
  # GET /accounts/new.xml
  def new
  	return false if !check_user(User::CREATE_ACCOUNTS,'No tiene los derechos suficientes para crear cuentas')
    @account = Account.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @account }
    end
  end

  # GET /accounts/1/edit
  def edit
  	return false if !check_user(User::CHANGE_ACCOUNTS,'No tiene los derechos suficientes para cambiar cuentas')
    @account = Account.find(params[:id])
  end

  # POST /accounts
  # POST /accounts.xml
  def create
  	return false if !check_user(User::CREATE_ACCOUNTS,'No tiene los derechos suficientes para crear cuentas')
    @account = Account.new(params[:account])

    respond_to do |format|
      if @account.save
        flash[:notice] = 'Cuenta ha sido creado exitosamente.'
        format.html { redirect_to(accounts_url) }
        format.xml  { render :xml => @accounts, :status => :created, :location => @account }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /accounts/1
  # PUT /accounts/1.xml
  def update
  	return false if !check_user(User::CHANGE_ACCOUNTS,'No tiene los derechos suficientes para cambiar cuentas')
    @account = Account.find(params[:id])

    respond_to do |format|
      if @account.update_attributes(params[:account])
        flash[:notice] = 'Cuenta ha sido actualizado exitosamente.'
        format.html { redirect_to(@account) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.xml
  def destroy
  	return false if !check_user(User::DELETE_ACCOUNTS,'No tiene los derechos suficientes para borrar cuentas')
    @account = Account.find(params[:id])
    @account.destroy

    respond_to do |format|
      format.html { redirect_to(accounts_url) }
      format.xml  { head :ok }
    end
  end
end
