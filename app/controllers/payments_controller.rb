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


class PaymentsController < ApplicationController
  # GET /payments
  # GET /payments.xml
  def index
    params[:from]=untranslate_month(params[:from]) if params[:from]
    params[:till]=untranslate_month(params[:till]) if params[:till]
  	@from=(params[:from] ||Date.today)
  	@till=(params[:till] ||Date.today)
  	@sites=(params[:sites] ||[User.current_user.location_id])
  	order_id=params[:order_id]
  	
  	if params[:pdf]=='1'
#      @payments = Payment.search(params[:search],@from, @till, @sites)
      @payments = Payment.search(params[:search], nil,@from, @till, @sites)
			if @payments.length==0
				flash[:error] = 'No hay Pagos para las fechas specificadas'
				redirect_back_or_default(payments_url)
				return false
			end
			produce_report
      params[:format] = 'pdf'
    else
      @payments = Payment.search(params[:search], (params[:page]||1),@from, @till, @sites)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @payments }
      format.pdf { render :template=>'payments/report', :layout => false }
    end
  end

  # GET /payments/1
  # GET /payments/1.xml
  def show
    @payment = Payment.find(params[:id])
    case @payment.order
    when Order::SALE
    	return false if !check_user(User::VIEW_PAYMENTS_FOR_SALES,'No tiene los derechos suficientes para ver los pagos de ventas')
    when Order::PURCHASE
    	return false if !check_user(User::VIEW_PAYMENTS_FOR_PURCHASES,'No tiene los derechos suficientes para ver los pagos de compras')
    end
		flash[:error] = 'Este pago esta anulado.' if @payment.canceled
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @payment }
    end
  end

  # GET /payments/new
  # GET /payments/new.xml
  def new
    @payment = Payment.new(:created_at=>User.current_user.today)
    @payment.order_id = params[:order_id]
    case @payment.order
    when Order::SALE
    	return false if !check_user(User::CREATE_PAYMENTS_FOR_SALES,'No tiene los derechos suficientes para crear pagos de ventas')
    when Order::PURCHASE
    	return false if !check_user(User::CREATE_PAYMENTS_FOR_PURCHASES,'No tiene los derechos suficientes para crear pagos de compras')
    end
		@payment.payment_method_id = 1
		@paid = @payment.order.amount_paid
		logger.debug "amount already paid = "+@paid.to_s + " or " + @payment.order.amount_paid.to_s
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @payment }
    end
  end
  def produce_report
  	return false if !check_user(User::VIEW_PAYMENTS_FOR_SALES,'No tiene los derechos suficientes para ver los pagos de ventas')
    @data=[]
		@site=User.current_user.location
		total=0
		x = Object.new.extend(ActionView::Helpers::NumberHelper)
		for payment in @payments
			if payment.order.client.user
				rep=payment.order.client.user.name
			else
				rep=""
			end
		  @data << [payment.order.receipt_number , payment.created_at.to_date.to_s(:rfc822), payment.order.client.name, x.number_to_currency(payment.amount),rep]
		  total+=payment.amount
		end
		@data << ["---", "---", "---", "---"]
		@data << ["", "", "Total", x.number_to_currency(total)]
		prawnto :prawn => { :page_size => 'LETTER'}
		params[:format] = 'pdf'
	end

  def edit
    @payment = Payment.find(params[:id])
    case @payment.order
    when Order::SALE
    	return false if !check_user(User::CHANGE_PAYMENTS_FOR_SALES,'No tiene los derechos suficientes para cambiar pagos de ventas')
    when Order::PURCHASE
    	return false if !check_user(User::CHANGE_PAYMENTS_FOR_PURCHASES,'No tiene los derechos suficientes para cambiar pagos de compras')
    end
		@paid = @payment.order.amount_paid-@payment.amount
		logger.debug "amount already paid = "+@paid.to_s + " or " + @payment.order.amount_paid.to_s
  end

  # POST /payments
  # POST /payments.xml
  def create
    @payment = Payment.new(params[:payment])
    case @payment.order
    when Order::SALE
    	return false if !check_user(User::CREATE_PAYMENTS_FOR_SALES,'No tiene los derechos suficientes para crear pagos de ventas')
    when Order::PURCHASE
    	return false if !check_user(User::CREATE_PAYMENTS_FOR_PURCHASES,'No tiene los derechos suficientes para crear pagos de compras')
    end
    @payment.created_at=User.current_user.today
    respond_to do |format|
      if @payment.save
        flash[:notice] = 'Pago ha sido creado exitosamente.'
        format.html { redirect_to(@payment.order) }
        format.xml  { render :xml => @payment, :status => :created, :location => @payment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @payment.errors, :status => :unprocessable_entity }
      end
    end
  end
  def update
    @payment = Payment.find(params[:id])
    case @payment.order
    when Order::SALE
    	return false if !check_user(User::CHANGE_PAYMENTS_FOR_SALES,'No tiene los derechos suficientes para cambiar pagos de ventas')
    when Order::PURCHASE
    	return false if !check_user(User::CHANGE_PAYMENTS_FOR_PURCHASES,'No tiene los derechos suficientes para cambiar pagos de compras')
    end
    @payment.attrs=params[:payment]
    respond_to do |format|
      if @payment.save
        flash[:notice] = 'Pago ha sido actualizado exitosamente.'
        format.html { redirect_to(@payment.order) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @payment.errors, :status => :unprocessable_entity }
      end
    end
  end
  def destroy
    @payment = Payment.find(params[:id])
    case @payment.order
    when Order::SALE
    	return false if !check_user(User::DELETE_PAYMENTS_FOR_SALES,'No tiene los derechos suficientes para borrar pagos de ventas')
    when Order::PURCHASE
    	return false if !check_user(User::DELETE_PAYMENTS_FOR_PURCHASES,'No tiene los derechos suficientes para borrar pagos de compras')
    end
		order=@payment.order
		@payment.void=1
		@payment.save
    @payment.destroy
    respond_to do |format|
      format.html { redirect_to(order) }
      format.xml  { head :ok }
    end
  end
end
