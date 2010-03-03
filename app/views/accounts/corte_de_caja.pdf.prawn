pdf.font_size = 15

@x = Object.new.extend(ActionView::Helpers::NumberHelper)
pdf.text "Corte de Caja en " + @site.name, :align => :center, :style => :bold
pdf.text COMPANY_NAME, :align => :center, :style => :bold
if @from.to_date == @till.to_date-1
	pdf.text @from.to_date.to_s(:long), :align => :center, :style => :bold
else
	pdf.text @from.to_date.to_s(:long) + " - " + (@till.to_date-1).to_s(:long), :align => :center, :style => :bold
end
pdf.font_size = 8
pdf.text "NIT:" + @site.nit_number, :align => :center if @site.nit
pdf.text "Registro:" + @site.register, :align => :center if @site.register
pdf.text @site.giro, :align => :center if @site.giro

pdf.text " "
#def series_to_list(series)
#	list=[]
#	for o in series
#		if list==[]
#			d={}
#			d[o.receipt_number.to_i]=o
#			list<<[d]
#		else
#			x=o.receipt_number.to_i
#			next if x==list.last.last
#			if x-1==list.last.last or x==list.last.last
#				list.last << x
#			else
#				list << [x]
#			end
#		end
#	end
#	return list
#end

def series_to_list(series)
	list=[]
	last=0
	for o in series
		if list==[]
			list<<[o.receipt_number]
			last=o.receipt_number.to_i
		else
			x=o.receipt_number.to_i
			next if x==last
			if x-1==last or x==last
				list.last << o.receipt_number
			else
				list << [o.receipt_number]
			end
			last=x
		end
	end
	return list
end
##################################################################################################
## 
##################################################################################################
#def series_to_list(series)
#	list=[]
#	for o in series
#		if list ==[]
#			list<<{o.receipt_number.to_i}
#		else
#		end
#	end
#end # def series_to_list(series)
def show_orders_info(tipo, title)
	#c="payments.id is not null AND payments.created_at>= '#{@from.to_s(:db)}' AND payments.created_at< '#{(@till + 1).to_s(:db)}' AND orders.received>= '#{@from.to_s(:db)}' AND orders.received< '#{(@till + 1).to_s(:db)}' AND entity_type_id=#{tipo} AND vendor_id = #{@site.id} AND orders.amount_paid>=orders.grand_total AND deleted =0 AND order_type_id=1"
	c="entity_type_id=#{tipo} AND vendor_id = #{@site.id} AND orders.amount_paid>=orders.grand_total AND order_type_id=1 AND orders.received>= '#{@from.to_s(:db)}' AND orders.received< '#{(@till).to_s(:db)}'"
	j="inner join entities on entities.id=client_id"
	g="orders.id"

	series=Order.find(:all, :conditions=>c, :joins=>j, :order=>'receipt_number')
	group_total=0
	for group in series_to_list(series)
		c="orders.receipt_number in(#{group.collect{|a| "'" + a.to_s + "', "}.to_s.chop.chop}) and order_type_id=1"
#		total=Order.find(:all, :conditions=>(c + cc), :joins=>j, :select=>'sum(grand_total) total')
		total=Order.sum(:grand_total, :conditions=>(c), :joins=>j)
		@box << [title,"del #{group.first} al #{group.last}",@x.number_to_currency(total)]
		group_total += total
		title=""
	end
	if series.length>1
  	@box << ["","Total:",@x.number_to_currency(group_total)] 
  else
    @box << [title,"Total:","$0.00"] 
  end
	
	return group_total
end

@box=[]
grand_total=0
grand_total += show_orders_info(Entity::CONSUMIDOR_FINAL,"Facturas Consumidor Final")
@box << ["","",""]
@box << ["","",""]
grand_total += show_orders_info(Entity::CREDITO_FISCAL,"Comprobantes de Credito Fiscal")
@box << ["","",""]
@box << ["","",""]


####################################################################################################
## Notas de Abono TODO
##################################################################################################
#c="payments.created_at>= '#{@from.to_s(:db)}' AND payments.created_at< '#{(@till + 1).to_s(:db)}' AND orders.received is null AND vendor_id = #{@site.id}"
#j="inner join orders on orders.id=order_id"
#s="payments.*, receipt_number"
#series = Payment.find(:all, :conditions=>c, :joins=>j, :select=>s)
#sum=series.inject(0) { |result, element| result + element.presented-element.returned }

#@box << ["Notas de Abono","Total:",@x.number_to_currency(sum)] if sum!=0
#for p in series
#	@box << ["",p.receipt_number,@x.number_to_currency(p.presented-p.returned)]
#end
@box << ["Notas de Abono","Total:","$0.00"]
####################################################################################################
## Facturas Credito
##################################################################################################
#c="orders.created_at>= '#{@from.to_s(:db)}' AND orders.created_at< '#{(@till + 1).to_s(:db)}' AND vendor_id = #{@site.id} AND orders.amount_paid<orders.grand_total AND order_type_id=1"
#j="left join payments on orders.id=order_id"
#series = Order.find(:all, :conditions=>c, :joins=>j, :group=>'orders.id')
#sum=series.inject(0) { |result, element| result + element.grand_total }

#first=true
#@box << ["Facturas Credito","Total:",@x.number_to_currency(sum)] if sum!=0
#for o in series
#	@box << ["",o.receipt_number,@x.number_to_currency(o.grand_total)]
#end
@box << ["Facturas Credito","Total:","$0.00"]
###################################################################################################
## Pagos de Facturas por Cobrar
## (Orders made within the period that have not been fully paid)
##################################################################################################
#c="payments.created_at>= '#{@from.to_s(:db)}' AND payments.created_at< '#{(@till + 1).to_s(:db)}' AND orders.created_at< '#{@from.to_s(:db)}' AND vendor_id = #{@site.id}"
#j="inner join payments on orders.id=order_id"
#series = Order.find(:all, :conditions=>c, :joins=>j)
#first=true
#for group in series_to_list(series)
#	cc=" AND orders.id in(${group.collect{|a| a.to_s + ", "}.to_s.chop.chop})"
#	total=Order.find(:all, :conditions=>c, :joins=>j, :select=>'sum(grand_total) total')[0].total
#	if first
#		@box << ["Pagos de Facturas por Cobrar","del #{group.first} al #{group.last}",@x.number_to_currency(total)]
#		first=false
#	else
#		@box << ["","del ${group.first} al ${group.last}",@x.number_to_currency(total)]
#	end
#end
@box << ["Pagos de Facturas por Cobrar","Total:","$0.00"]
##################################################################################################
# Devoluciones
#################################################################################################
c="orders.deleted_at>= '#{@from.to_s(:db)}' AND orders.deleted_at< '#{(@till).to_s(:db)}' AND vendor_id = #{@site.id} AND order_type_id=1"
j="inner join payments on orders.id=order_id"
series = Order.find(:all, :conditions=>c, :joins=>j)
first=true
total=0
for order in series
	cc=" AND orders.id =#{order.id})"
	value=order.total_price_with_tax
	total+=value
	if first
		@box << ["Devoluciones",order.receipt_number,"(#{@x.number_to_currency(value)})"]
		first=false
	else
		@box << ["",order.receipt_number,"(#{@x.number_to_currency(value)})"]
	end
end
@box << ["","Total","(#{@x.number_to_currency(total)})"] if series.length>1
grand_total-=total
if series.length==0
  @box << ["Devoluciones","Total","$0.00"]
end

@box << ["","",""]
@box << ["","",""]
#@box << ["","Total Final",@x.number_to_currency(grand_total)]

##################################################################################################
# autoconsumos
#################################################################################################





##################################################################################################
# now print it out
#################################################################################################
a=(pdf.bounds.width*0.6)
b=(pdf.bounds.width*0.2)
	pdf.table(@box,
		 :font_size => 10,
		 :horizontal_padding => 1,
		 :vertical_padding => 5,
		 :border_width => 1,
		 :border_style => :underline_header,
		 :column_widths => { 0 => a, 1 => b, 2 => b },
		 :align => { 0 => :left,1 => :left, 2 => :left })
pdf.font_size = 10
pdf.number_pages "pagina <page> de <total>", [pdf.bounds.right - 50, 0]

