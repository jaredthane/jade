pdf.start_new_page(
	:size => 'LETTER',
	:left_margin=>0,
  :right_margin=>0,
  :top_margin=>0,
  :bottom_margin=>0)
y=pdf.bounds.height
client=@order.client
vendor=@order.vendor
for copy in ['cliente', 'vendor'] do
		#pdf.stroke_bounds
	pdf.bounding_box([0,y], :width=>pdf.bounds.width, :height=>(pdf.bounds.height)/2) do
		pdf.padded_box(25) do
			#pdf.stroke_bounds
			##################################################################################################
			# Put company name in top-left corner
			#################################################################################################
			pdf.bounding_box([pdf.bounds.left, pdf.bounds.top], :width=>pdf.bounds.width*2/3, :height=>20) do
				#pdf.stroke_bounds
				pdf.font_size = 14
				pdf.text COMPANY_NAME + ' ' + @order.id.to_s, :style=>:bold
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
				if client.id != 3
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
							pdf.text "NIT: " + (client.nit||'')
						end #if vendor.office_phone!=''
					end
				end
			end # client first box
			# Put the client information in the top-right corner
			if client.id != 3
				pdf.bounding_box([pdf.bounds.width/3*2, pdf.bounds.top-30], :width=>pdf.bounds.width/3, :height=>65) do
					#pdf.stroke_bounds
					pdf.font_size = 10
					if client.home_phone!=''
						pdf.text "Fijo: " + (client.home_phone_number||'')
					end #if vendor.home_phone!=''
					if client.office_phone!=''
						pdf.text "Oficina: " + (client.office_phone_number||'')
					end #if vendor.office_phone!=''
					if client.office_phone!=''
						pdf.text "Celular: " + (client.cell_phone_number||'')
					end #if vendor.office_phone!=''
					if client.email!=''
						pdf.text client.email
					end #if vendor.email!=''
					if client.giro!=''
						pdf.text "Giro: " + (client.giro||'')
					end #if client.giro!=''
				end # client second box
			end
			# Poner tabla de productos
			pdf.move_up 10
			data=[]
			pdf.font_size = 9
			total=0
			iva=0
			width=pdf.bounds.width
			for l in @order.lines
				x = Object.new.extend(ActionView::Helpers::NumberHelper)
				if l.product.serialized and l.serialized_product
						data << [l.quantity.to_s, l.product.name + " - " + l.serialized_product.serial_number, x.number_to_currency(l.price), x.number_to_currency(l.total_price)]
				else
					data << [l.quantity.to_s, l.product.name, x.number_to_currency(l.price),  x.number_to_currency(l.total_price)]
				end
				total += l.total_price
				iva+=l.tax
			end  
			data << ["", "", "Suma", number_to_currency(total)]
			data << ["", "", "IVA", number_to_currency(iva)]
			data << ["", "", "Total", number_to_currency(total+iva)]
			if data.length>0
				pdf.table(data,
						:at=>[0,pdf.cursor],
						:font_size => 8,
						:align => { 0 => :center, 1 => :left, 2 => :center, 3 => :center },
						:headers => ['Cantidad', 'Producto', 'Unidad','Total'],
						:border_style => :underline_header,
						:column_widths => { 0 => 0.13*width, 1 => 0.6*width, 2 => 0.13*width, 3 => 0.13*width})
			else
				pdf.font_size = 10
				pdf.text "Esta venta no contiene ningunos productos.", :align => :center, :style => :bold
			end	  
		end # receipt box
	end # padded box
	pdf.move_down 25
	y-=pdf.bounds.height/2
end # for each copy holder
