pdf.start_new_page(
	:size => 'LETTER')
pdf.font_size = 15
pdf.text "Listado de Productos", :align => :center, :style => :bold
pdf.text COMPANY_NAME, :align => :center, :style => :bold
data=[]
x = Object.new.extend(ActionView::Helpers::NumberHelper)
for p in @products
	q=(p.quantity||0)
	c=(p.cost||0)
	data << [ p.name,	q, c,q*c]
end
pdf.font_size = 10
pdf.table(data,
   :font_size => 10,
   :headers => ['Producto', 'Cantidad', 'Costo','Total'],
   :horizontal_padding => 1,
   :vertical_padding => 1,
   :border_width => 0,
   :border_style => :underline_header,
   :column_widths => { 0 => 300, 1 => 100, 2 => 100, 3 => 100 },
   :align => { 0 => :left,1 => :center, 2 => :center, 3 => :center })
