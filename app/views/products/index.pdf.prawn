pdf.start_new_page(
	:size => 'LETTER')
pdf.font_size = 15
x = Object.new.extend(ActionView::Helpers::NumberHelper)
pdf.text "Listado de Productos - #{@date}", :align => :center, :style => :bold
pdf.text COMPANY_NAME, :align => :center, :style => :bold
data=[]
x = Object.new.extend(ActionView::Helpers::NumberHelper)
for p in @products
	q=(p.quantity||0)
	price=(p.price||0)
	c=(p.cost||0)
	data << [p.upc,  p.name,	q, x.number_to_currency(price), x.number_to_currency(c),x.number_to_currency(q*c)]
end
pdf.font_size = 10
pdf.table(data,
   :font_size => 10,
   :headers => ['Codigo', 'Producto', 'Cantidad', 'Precio', 'Costo','Total'],
   :horizontal_padding => 1,
   :vertical_padding => 1,
   :border_width => 0,
   :border_style => :underline_header,
   :column_widths => {0 => 50, 1 => 300, 2 => 50, 3 => 50, 4 => 50, 5 => 50 },
   :align => { 0 => :left,1 => :center, 2 => :center, 3 => :center, 4 => :center, 5 => :center })
pdf.move_down 10
pdf.text "Total - #{x.number_to_currency(@total)}", :align => :right, :style => :bold

pdf.font_size = 10
pdf.number_pages "Pagina <page> de <total>", [pdf.bounds.right - 80, -10]
