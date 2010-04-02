class ReportTemplatesController < ApplicationController
	before_filter :login_required
  def index
    @reports=ReportTemplate.all()
    respond_to do |format|
      format.html
    end
  end
  def show
    @report=ReportTemplate.find(params[:id])
    respond_to do |format|
      format.html
    end
  end
  def edit
    @report=ReportTemplate.find(params[:id])
  end
  def update
    @report=ReportTemplate.find(params[:id])
    respond_to do |format|
      if @report.update_attributes(params[:report_template])
        flash[:notice] = 'Plantilla de reporte ha sido actualizada exitosamente.'
        format.html { redirect_to(@report) }
      else
        format.html { render :action => "edit" }
      end
    end
  end
end
