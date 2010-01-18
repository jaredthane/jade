pdf.start_new_page(
	:size => 'LETTER')
pdf.font_size = 15
pdf.text "Transacciones de " + @site.name, :align => :center, :style => :bold
pdf.text COMPANY_NAME, :align => :center, :style => :bold
pdf.text @from.to_date.to_s(:long) + " - " + @till.to_date.to_s(:long), :align => :center, :style => :bold
data=[]
x = Object.new.extend(ActionView::Helpers::NumberHelper)
for post in @posts
	data << [(post.trans.order.receipt_number||'Sin número'), 
						post.created_at.to_date, 
						truncate(post.trans.order.client.name), 
						x.number_to_currency(post.value*post.post_type_id), 
						post.trans.user.name]
end
pdf.font_size = 12
pdf.table(data,
   :font_size => 12,
   :headers => ['Num. Factura', 'Fecha de Factura', 'Cliente','Cantidad','Asesor'],
   :horizontal_padding => 1,
   :vertical_padding => 1,
   :border_width => 0,
   :border_style => :underline_header,
   :column_widths => { 0 => 80, 1 => 100, 2 => 200, 3 => 60, 4 => 160 },
   :align => { 0 => :left,1 => :left, 2 => :left, 3 => :left, 4 => :left })
