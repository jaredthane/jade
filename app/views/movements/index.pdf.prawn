pdf.start_new_page(
	:size => 'LETTER')
pdf.font_size = 20
pdf.text "Movimientos de Inventario ", :align => :center, :style => :bold
pdf.font_size = 10
pdf.text COMPANY_NAME, :align => :center
if @till! = @from
	pdf.text "#{@from.to_date} - #{@till.to_date}", :align => :center
else
	pdf.text "#{@till.to_date}", :align => :center
end

data=[]
for m in @movements
    case m.movement_type_id
    when Movement::SALE
    	data << [m.id, m.created_at, m.order.receipt_number, m.client.name, m.quantity, m.quantity * m.line.cost, m.line.price]
end
#width=pdf.bounds.width

#if data.length>0
#	pdf.table(data,
#		:font_size => 8,
#		:align => { 0 => :center, 1 => :left, 2 => :center, 3 => :center, 4 => :center, 5 => :center },
#		:headers => ['Codigo', 'Producto', 'Locacion', 'Unidad', 'Cantidad Anterior', 'Cuenta'],
#		:border_style => :grid,
#		:column_widths => { 0 => 0.12*width, 1 => 0.4*width, 2 => 0.12*width, 3 => 0.12*width, 4 => 0.12*width, 5 => 0.12*width})	 
#else
#	pdf.font_size = 10
#	pdf.text "Esta cuenta no contiene ningunos productos.", :align => :center, :style => :bold
#end

pdf.font_size = 8
pdf.number_pages "Pagina <page> de <total>", [pdf.bounds.right-50, 0]
