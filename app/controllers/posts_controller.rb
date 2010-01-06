class PostsController < ApplicationController
# GET /warranties/new
  # GET /warranties/new.xml
  def new
  	@post=Post.new(:trans_id=>params[:trans_id])
    @accounts ={} 
    for a in Account.find(:all)
      @accounts[a.number.to_s+' '+a.name]=a.id
    end
    respond_to do |format|
      format.html # new.html.erb
      format.js { render :partial => 'trans/post', :object => @post}
      format.xml  { render :xml => @trans }
    end
  end
	def index
		return false if !check_user(User::VIEW_ACCOUNTS,'No tiene los derechos suficientes para ver las cuentas')
	  @from=(untranslate_month(params[:from])||Date.today)
    @till=(untranslate_month(params[:till])||Date.today)
    @site=current_user.location
    @sites=(params[:sites] || [])
			debugger
		if params[:pdf]=='1'
      @posts = Post.search(1, @from, @till, nil,params[:sites])
      params[:format] = 'pdf'
    else
      @posts = Post.search(1, @from, @till, (params[:page]||1), params[:sites])
    end
		respond_to do |format|
		  format.html # index.html.erb
		  format.pdf {
		    prawnto :prawn => {:skip_page_creation=>true}
		  }
		end
	end
end
