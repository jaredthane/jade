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
end
