pdf.start_new_page(
	:size => 'LEGAL',
	:left_margin=>0,
  :right_margin=>0,
  :top_margin=>0,
  :bottom_margin=>0)
y=pdf.bounds.height
client=@receipt.order.client
vendor=@receipt.order.vendor
for copy in ['cliente', 'vendor', 'government'] do
		#pdf.stroke_bounds
	pdf.bounding_box([0,y], :width=>pdf.bounds.width, :height=>(pdf.bounds.height)/3) do
		pdf.padded_box(25) do
			#pdf.stroke_bounds
			##################################################################################################
			# Put company name in top-left corner
			#################################################################################################
			pdf.bounding_box([pdf.bounds.left, pdf.bounds.top], :width=>pdf.bounds.width*2/3, :height=>20) do
				#pdf.stroke_bounds
				pdf.font_size = 14
				pdf.text COMPANY_NAME, :style=>:bold
			end # company name bounding box
			##################################################################################################
			# 
			#################################################################################################
			# Put the companies contact information in the below the name
			pdf.bounding_box([pdf.bounds.left, pdf.bounds.top-15], :width=>pdf.bounds.width/3-40, :height=>85) do
				#pdf.stroke_bounds
				pdf.font_size = 10
				if vendor.address != ''
					pdf.text vendor.address
				end #vendor.address
				if vendor.office_phone_number !='' 
					pdf.text vendor.office_phone_number
				end #office_phone_number
				if vendor.email != ''
					pdf.text vendor.email
				end #if vendor.email != ''
			end
			
			pdf.line [pdf.bounds.width/3-40, pdf.bounds.top-25], [540, pdf.bounds.top-25]
			# Put the client information in the top-right corner
			pdf.text "Cliente:",:at=>[pdf.bounds.width/3-40, pdf.bounds.top-37]
			pdf.bounding_box([pdf.bounds.width/3, pdf.bounds.top-30], :width=>pdf.bounds.width/3, :height=>65) do
				#pdf.stroke_bounds
				pdf.font_size = 12
				pdf.text client.name, :style=>:bold
				pdf.font_size = 10
				if client.full_address
				  if client.full_address != ''
					  pdf.text truncate(client.full_address,50)
				  end #if client.full_address != ''
				end
				if client.register
				  if client.register!=''
					  pdf.text "Registro: " + client.register
				  end #if vendor.office_phone!=''
				end
				if client
				  if client.nit!=''
					  pdf.text "NIT: " + client.nit
				  end #if vendor.office_phone!=''
				end
			end # client first box
			# Put the client information in the top-right corner
			pdf.bounding_box([pdf.bounds.width/3*2, pdf.bounds.top-30], :width=>pdf.bounds.width/3, :height=>65) do
				#pdf.stroke_bounds
				pdf.font_size = 10
				if client.home_phone!=''
					pdf.text "Fijo: " + client.home_phone_number
				end #if vendor.home_phone!=''
				if client.office_phone!=''
					pdf.text "Oficina: " + client.office_phone_number
				end #if vendor.office_phone!=''
				if client.office_phone!=''
					pdf.text "Celular: " + client.cell_phone_number
				end #if vendor.office_phone!=''
				if client.email!=''
					pdf.text client.email
				end #if vendor.email!=''
				if client.giro!=''
					pdf.text "Giro: " + client.giro
				end #if client.giro!=''
			end # client second box
			# Poner tabla de productos
			pdf.move_up 10
			data=[]
			pdf.font_size = 9
			total=0
			iva=0
			width=pdf.bounds.width
			for l in @receipt.lines
				x = Object.new.extend(ActionView::Helpers::NumberHelper)
				if l.product.serialized
					if l.serialized_product
						data << [l.quantity.to_s, l.product.name + " - " + l.serialized_product.serial_number, x.number_to_currency(l.price), x.number_to_currency(l.total_price)]
					end
				else
					data << [l.quantity.to_s, l.product.name, x.number_to_currency(l.price),  x.number_to_currency(l.total_price)]
				end
				total += l.total_price
				iva+=l.tax
			end  
			data << ["", "", "Suma", number_to_currency(total)]
			data << ["", "", "IVA", number_to_currency(iva)]
			data << ["", "", "Total", number_to_currency(total+iva)]
			pdf.table(data,
					:at=>[0,pdf.cursor],
				  :font_size => 8,
				  :align => { 0 => :center, 1 => :left, 2 => :center, 3 => :center },
				  :headers => ['Cantidad', 'Producto', 'Unidad','Total'],
				  :border_style => :underline_header,
				  :column_widths => { 0 => 0.13*width, 1 => 0.6*width, 2 => 0.13*width, 3 => 0.13*width})	  
		end # receipt box
	end # padded box
	pdf.move_down 25
	y-=pdf.bounds.height/3
end # for each copy holder
