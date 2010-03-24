pdf.start_new_page(
	:size => 'LETTER')
pdf.font_size = 10
per_row=5
per_column=7
data=[]
x = Object.new.extend(ActionView::Helpers::NumberHelper)
count=0
for l in @order.lines
	for i in (1..l.quantity)
		pdf.text truncate(l.product.name,20), :at => [pdf.bounds.left + (count % per_row) * 120 - 30, pdf.bounds.top + 7 - (count / per_row).to_i * 100] 
		pic="#{RAILS_ROOT}/public/#{l.product.barcode_filename}"
		pdf.image pic, :at => [pdf.bounds.left + (count % per_row) * 120 - 30 , pdf.bounds.top - (count / per_row).to_i * 100] 
		count += 1
		if count == per_row * per_column
			pdf.start_new_page() 
			count=0
		end
	end
end

