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


class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
	before_filter :login_required
	access_control [:new, :create, :destroy] => '(Gerente | Admin)' 
  
	def index
    @users = User.search(params[:search], params[:page])
		if !current_user.has_rights(['Admin','Gerente'])
			redirect_back_or_default('/products')
			flash[:error] = "No tiene los derechos suficientes para alistar los usuarios"
		end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @entities }
      format.js
    end
  end
  # render new.rhtml
#  def new
#  end

  def create
#    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    params[:today]=untranslate_month(params[:today]) if params[:today]
    
    @user = User.new(params[:user])
    @user.location= current_user.location
    @user.default_received = false
    @user.save
    if @user.errors.empty?
#      self.current_user = @user
      redirect_back_or_default('/products')
      flash[:notice] = "Nuevo usuario creado exitosamente"
    else
      render :action => 'new'
    end
  end


# GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])
    logger.debug "@user=#{@user.to_s}"
    logger.debug "current_user=#{current_user.to_s}"
    logger.debug "current_user.has_rights(['Admin','Gerente'])=#{current_user.has_rights(['Admin','Gerente']).to_s}"
		if @user!=current_user and !current_user.has_rights(['Admin','Gerente'])
			redirect_back_or_default('/products')
			flash[:error] = "No tiene los derechos suficientes para ver otros usuarios"
		end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end
  # GET /users/1
  # GET /users/1.xml
  def show_me
    @user = current_user
    render :action => 'show'
    return false
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new
		if !current_user.has_rights(['Admin','Gerente'])
			redirect_back_or_default('/products')
			flash[:error] = "No tiene los derechos suficientes para crear nuevos usuarios"
		end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    if @user!=current_user and !current_user.has_rights(['Admin','Gerente'])
			redirect_back_or_default('/products')
			flash[:error] = "No tiene los derechos suficientes para modificar otros usuarios"
		end
  end
	def new_role	
		@role = RolesUser.new(:user_id => params[:roles_user][:user_id], :role_id => params[:roles_user][:role_id])
#		logger.debug "@role.user_id=#{@role.user_id.to_s}"
#		logger.debug "@role.role_id=#{@role.role_id.to_s}"
#		logger.debug "params[:format]=#{params[:format].to_s}"
		respond_to do |format|
			format.html do
				logger.debug " ======================================>  html requested"
				redirect_to '/users/' + @role.user_id.to_s + '/edit'
			end
			format.js do
        render :update do |page|
        	page.replace_html 'roles_errors', ""
					puts @role.inspect
          page.insert_html :bottom, :roles, :partial => 'role', :object => @role
        end
      end
    end
	end
  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])
    if @user!=current_user and !current_user.has_rights(['Admin','Gerente'])
			redirect_back_or_default('/users')
			flash[:error] = "No tiene los derechos suficientes para modificar otros usuarios"
		end
		params[:user][:today]=untranslate_month(params[:user][:today])
		logger.debug "Month has been translated to:" + params[:user][:today]
		to_delete=[]
		#Update existing reqs
    for l in @user.roles_users
			if params['existing_roles']
				if params['existing_roles'][l.id.to_s]
					logger.debug "UPDATING l=#{l.inspect}"
					l.attributes = params['existing_roles'][l.id.to_s]
				else
					logger.debug "DELETING l=#{l.inspect}"
					@user.roles_users.delete(l)
				end
			else
				logger.debug "DELETING l=#{l.inspect}"
				@user.roles_users.delete(l)
			end
		end
		
		# Update New roles
		list= params['new_roles'] || []
  	for l in list
  		logger.debug "ADDING l=#{l.inspect}"
  		new_role = RolesUser.new(:user_id=>@user.id)
  		new_role.update_attributes(l)
  		@user.roles_users.push(new_role)
  	end
  	if current_user.has_rights(['Admin','Gerente','contabilidad'])
  	  @user.cash_account_id = params[:user][:cash_account_id]
  	  @user.revenue_account_id = params[:user][:revenue_account_id]
  	  @user.personal_account_id = params[:user][:personal_account_id]
  	end
		if  @user.update_attributes(params[:user])
			flash[:notice] = 'Usuario ha sido actualizado exitosamente.'
		end
	redirect_to(user_path(@user))

  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
end


