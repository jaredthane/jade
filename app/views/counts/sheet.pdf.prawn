pdf.start_new_page(
	:size => 'LETTER')
pdf.font_size = 20
pdf.text "Cuenta Fisica - " + @order.created_at.to_date.to_s, :align => :center, :style => :bold
data=[]
for l in @order.lines
	data << [l.product.upc, l.product.name, l.product.location, l.product.unit.name, l.product.quantity, l.quantity==0 ? '' : l.quantity.to_s]
end
width=pdf.bounds.width

if data.length>0
	pdf.table(data,
		:font_size => 8,
		:align => { 0 => :center, 1 => :left, 2 => :center, 3 => :center, 4 => :center, 5 => :center },
		:headers => ['Codigo', 'Producto', 'Locacion', 'Unidad', 'Cantidad Anterior', 'Cuenta'],
		:border_style => :grid,
		:column_widths => { 0 => 0.12*width, 1 => 0.4*width, 2 => 0.12*width, 3 => 0.12*width, 4 => 0.12*width, 5 => 0.12*width})	 
else
	pdf.font_size = 10
	pdf.text "Esta cuenta no contiene ningunos productos.", :align => :center, :style => :bold
end
