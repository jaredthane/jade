class WarrantiesController < ApplicationController
  # GET /warranties
  # GET /warranties.xml
  def index
		@warranties = Warranty.search(params[:search], params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @warranties }
    end
  end

  # GET /warranties/1
  # GET /warranties/1.xml
  def show
    @warranty = Warranty.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @warranty }
    end
  end

  # GET /warranties/new
  # GET /warranties/new.xml
  def new
    @warranty = Warranty.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @warranty }
    end
  end

  # GET /warranties/1/edit
  def edit
    @warranty = Warranty.find(params[:id])
  end

  # POST /warranties
  # POST /warranties.xml
  def create
    @warranty = Warranty.new(params[:warranty])

    respond_to do |format|
      if @warranty.save
        flash[:notice] = 'Garantía ha sido creado exitosamente.'
        format.html { redirect_to(warranties_url) }
        format.xml  { render :xml => @warranties, :status => :created, :location => @warranty }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @warranty.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /warranties/1
  # PUT /warranties/1.xml
  def update
    @warranty = Warranty.find(params[:id])

    respond_to do |format|
      if @warranty.update_attributes(params[:warranty])
        flash[:notice] = 'Garantía ha sido actualizado exitosamente.'
        format.html { render :action => "index" }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @warranty.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /warranties/1
  # DELETE /warranties/1.xml
  def destroy
    @warranty = Warranty.find(params[:id])
    @warranty.destroy

    respond_to do |format|
      format.html { redirect_to(warranties_url) }
      format.xml  { head :ok }
    end
  end
end
