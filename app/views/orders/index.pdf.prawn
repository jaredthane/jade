@data=[]
total=0
x = Object.new.extend(ActionView::Helpers::NumberHelper)
for order in @orders
	if order.client.user
  	username=order.client.user.name
  else
  	username=""
  end
  if order.deleted
  	if order.created_at.to_date==order.deleted
  		value='Anulado'
  	else
  		value=x.number_to_currency(-order.grand_total)
  		total-=order.grand_total
  	end
  else
  	value=x.number_to_currency(order.grand_total)
  	total+=order.grand_total
  end
  @data << [order.number, order.created_at.to_date.to_s, order.client.name, value, username]

end
@data << ["---", "---", "---", "---"]
@data << ["", "", "Total", x.number_to_currency(total)]

pdf.font_size = 15
pdf.text "Facturas de " + @site.name, :align => :center, :style => :bold
pdf.text COMPANY_NAME, :align => :center, :style => :bold
pdf.text @from.to_date.to_s(:long) + " - " + @till.to_date.to_s(:long), :align => :center, :style => :bold

pdf.font_size = 12
pdf.table(@data,
   :font_size => 12,
   :headers => ['Num. Factura', 'Fecha', 'Cliente','Cantidad','Asesor'],
   :horizontal_padding => 1,
   :vertical_padding => 1,
   :border_width => 0,
   :border_style => :underline_header,
   :column_widths => { 0 => 80, 1 => 100, 2 => 200, 3 => 60, 4 => 160 },
   :align => { 0 => :left,1 => :left, 2 => :left, 3 => :left, 4 => :left })
