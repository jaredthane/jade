pdf.start_new_page(:size => 'LETTER')
pdf.font_size = 20
pdf.text "Movimientos de Inventario ", :align => :center, :style => :bold
pdf.font_size = 10
pdf.text COMPANY_NAME, :align => :center
if @till != @from
	pdf.text "#{@from.to_date} - #{@till.to_date}", :align => :center
else
	pdf.text "#{@till.to_date}", :align => :center
end
  
data=[]
total={}
value={}
@movements.reverse!
for m in @movements    
  total[m.product] = (total.has_key?(m.product) ? total[m.product] + m.quantity : +m.quantity)
  case m.movement_type_id
  when Movement::SALE
   value[m.product] = (value.has_key?(m.product) ? value[m.product] - (m.cost||0) : (m.cost||0))
  	data.unshift([m.id, "Venta", m.created_at.to_date, m.order.receipt_number, m.order.client.name, m.product.name, m.quantity, number_to_currency(m.cost/m.quantity), total[m.product], number_to_currency(value[m.product])])
  when Movement::PURCHASE
    value[m.product] = (value.has_key?(m.product) ? value[m.product] + (m.cost||0) : (m.cost||0))
  	data.unshift([m.id, "Compra", m.created_at.to_date, m.order.receipt_number, m.order.vendor.name, m.product.name, m.quantity, number_to_currency(m.cost/m.quantity), total[m.product], number_to_currency(value[m.product])])
  when Movement::COUNT
    value[m.product] = (value.has_key?(m.product) ? value[m.product] + (m.cost||0) : (m.cost||0))
  	data.unshift([m.id, "Cuenta Fisica", m.created_at.to_date, m.order.id.to_s,"", m.product.name, m.quantity, number_to_currency(m.cost/m.quantity), total[m.product], number_to_currency(value[m.product])])
  end
end
width=pdf.bounds.width
data.reverse!

if data.length>0
	pdf.table(data,
		:font_size => 8,
		:align => { 0 => :center, 1 => :left, 2 => :center, 3 => :center, 4 => :center, 5 => :center , 6 => :center , 7 => :center, 8 => :center, 9 => :center },
		:headers => ['ID',      'Tipo',     'Fecha',     'Factura',    'Entidad',   'Producto',    'Cantidad', 'Valor Unitario', 'Existencias', 'Saldo'],
		:border_style => :grid,
		:column_widths => { 0 => 0.05*width, 1 => 0.10*width, 2 => 0.10*width, 3 => 0.10*width, 4 => 0.10*width, 5 => 0.15*width, 6 => 0.10*width, 7 => 0.10*width, 8 => 0.10*width, 9 => 0.10*width})
else
	pdf.font_size = 10
	pdf.text "No hubieron ningunos movimientos en las fechas specificadas.", :align => :center, :style => :bold
end

pdf.font_size = 8
pdf.number_pages "Pagina <page> de <total>", [pdf.bounds.right-50, 0]
