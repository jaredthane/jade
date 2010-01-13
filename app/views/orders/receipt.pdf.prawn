pdf.start_new_page(
	:size => 'LETTER',
	:left_margin=>0,
  :right_margin=>0,
  :top_margin=>-10,
  :bottom_margin=>0)
y=pdf.bounds.height
client=@order.client
vendor=@order.vendor
for copy in ['cliente', 'vendor'] do
	#pdf.stroke_bounds
	pdf.bounding_box([0,y], :width=>pdf.bounds.width, :height=>(pdf.bounds.height)/2+17) do
		#pdf.stroke_bounds
		pdf.padded_box(25) do
			#pdf.stroke_bounds
			pdf.font_size = 10
			pdf.text User.current_user.today.to_date, :at=>[pdf.bounds.left + 225,pdf.bounds.bottom+355]
			pdf.font_size = 12
			pdf.text client.name, :style=>:bold, :at=>[pdf.bounds.left + 225,pdf.bounds.bottom+335]
			pdf.font_size = 8
			if client.full_address
				pdf.text truncate(client.full_address,100), :at=>[pdf.bounds.left + 225,pdf.bounds.bottom+317]
			end
			pdf.font_size = 10
			if client
				if client.nit!=''
					pdf.text (client.nit||''), :at=>[pdf.bounds.left + 225,pdf.bounds.bottom+317]
				end #if vendor.office_phone!=''
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
						data << [l.quantity.to_s, l.product.name + " - " + l.serialized_product.serial_number, x=(l.price), x.number_to_currency(l.total_price)]
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
						:vertical_padding => 1,
						:column_widths => { 0 => 0.13*width, 1 => 0.6*width, 2 => 0.13*width, 3 => 0.13*width})

			else
				#data << [l.quantity.to_s, l.product.name, x.number_to_currency(l.price),  x.number_to_currency(l.total_price)]
        pdf.text l.quantity,:at=>[pdf.bounds.left + 35, pdf.bounds.bottom + 230 - (line*10)]
        pdf.text l.product.name,:at=>[pdf.bounds.left + 75, pdf.bounds.bottom + 230 - (line*10)]
        pdf.text x.number_to_currency(l.price),:at=>[pdf.bounds.left + 435, pdf.bounds.bottom + 230 - (line*10)]
        pdf.text x.number_to_currency(l.total_price),:at=>[pdf.bounds.left + 510, pdf.bounds.bottom + 230 - (line*10)]
			end
			total += l.total_price
			iva+=l.tax
			line +=1
		end
    pdf.text number_to_currency(total),:at=>[pdf.bounds.left + 500, pdf.bounds.bottom+67]
    pdf.text number_to_currency(iva),:at=>[pdf.bounds.left + 500, pdf.bounds.bottom+47]
    pdf.text number_to_currency(total+iva),:at=>[pdf.bounds.left + 500, pdf.bounds.bottom+27]

#    pdf.text 'a',:at=>[pdf.bounds.left + 35, pdf.bounds.bottom+250]
#    pdf.text 'b',:at=>[pdf.bounds.left + 75, pdf.bounds.bottom+250]
#    pdf.text 'c',:at=>[pdf.bounds.left + 435, pdf.bounds.bottom+250]
#    pdf.text 'd',:at=>[pdf.bounds.left + 510, pdf.bounds.bottom+250]
#		pdf.font_size = 7
#    pdf.text 1,:at=>[pdf.bounds.left + 210, pdf.bounds.bottom+50]
#    pdf.text 2,:at=>[pdf.bounds.left + 210, pdf.bounds.bottom+100]
#    pdf.text 3,:at=>[pdf.bounds.left + 210, pdf.bounds.bottom+150]
#    pdf.text 4,:at=>[pdf.bounds.left + 210, pdf.bounds.bottom+200]
#    pdf.text 5,:at=>[pdf.bounds.left + 210, pdf.bounds.bottom+250]
#    pdf.text 6,:at=>[pdf.bounds.left + 210, pdf.bounds.bottom+300]
#    pdf.text 7,:at=>[pdf.bounds.left + 210, pdf.bounds.bottom+350]
#    pdf.text 8,:at=>[pdf.bounds.left + 210, pdf.bounds.bottom+400]
#    pdf.text 9,:at=>[pdf.bounds.left + 210, pdf.bounds.bottom+450]
#    pdf.text 0,:at=>[pdf.bounds.left + 210, pdf.bounds.bottom+500]
#    pdf.text 1,:at=>[pdf.bounds.left + 210, pdf.bounds.bottom+550]

#		pdf.text 'a',:at=>[pdf.bounds.left + 200, pdf.bounds.bottom+310]
#		pdf.text 'b',:at=>[pdf.bounds.left + 205, pdf.bounds.bottom+310]
#		pdf.text 'c',:at=>[pdf.bounds.left + 210, pdf.bounds.bottom+310]
#		pdf.text 'd',:at=>[pdf.bounds.left + 215, pdf.bounds.bottom+310]
#		pdf.text 'e',:at=>[pdf.bounds.left + 220, pdf.bounds.bottom+310]
#		pdf.text 'f',:at=>[pdf.bounds.left + 225, pdf.bounds.bottom+310]
#		pdf.text 'g',:at=>[pdf.bounds.left + 230, pdf.bounds.bottom+310]
#		pdf.text 'h',:at=>[pdf.bounds.left + 235, pdf.bounds.bottom+310]
#		pdf.text 'i',:at=>[pdf.bounds.left + 240, pdf.bounds.bottom+310]
#		pdf.text 'j',:at=>[pdf.bounds.left + 245, pdf.bounds.bottom+310]
#		pdf.text 'k',:at=>[pdf.bounds.left + 250, pdf.bounds.bottom+310]
#		pdf.text 'l',:at=>[pdf.bounds.left + 255, pdf.bounds.bottom+310]
#		pdf.text 'm',:at=>[pdf.bounds.left + 260, pdf.bounds.bottom+310]
#		pdf.text 'n',:at=>[pdf.bounds.left + 265, pdf.bounds.bottom+310]
#		pdf.text 'o',:at=>[pdf.bounds.left + 270, pdf.bounds.bottom+310]
#		pdf.text 'p',:at=>[pdf.bounds.left + 275, pdf.bounds.bottom+310]
#		pdf.text 'q',:at=>[pdf.bounds.left + 280, pdf.bounds.bottom+310]
#		pdf.text 'r',:at=>[pdf.bounds.left + 285, pdf.bounds.bottom+310]
#		pdf.text 's',:at=>[pdf.bounds.left + 290, pdf.bounds.bottom+310]
#		pdf.text 't',:at=>[pdf.bounds.left + 295, pdf.bounds.bottom+310]


#		pdf.text '-7',:at=>[pdf.bounds.left + 220, pdf.bounds.bottom+350]
#		pdf.text '-6',:at=>[pdf.bounds.left + 220, pdf.bounds.bottom+300]
#		pdf.text '-a',:at=>[pdf.bounds.left + 220, pdf.bounds.bottom+305]
#		pdf.text '-b',:at=>[pdf.bounds.left + 220, pdf.bounds.bottom+310]
#		pdf.text '-c',:at=>[pdf.bounds.left + 220, pdf.bounds.bottom+315]
#		pdf.text '-d',:at=>[pdf.bounds.left + 220, pdf.bounds.bottom+320]
#		pdf.text '-e',:at=>[pdf.bounds.left + 220, pdf.bounds.bottom+325]
#		pdf.text '-f',:at=>[pdf.bounds.left + 220, pdf.bounds.bottom+330]
#		pdf.text '-g',:at=>[pdf.bounds.left + 220, pdf.bounds.bottom+335]
#		pdf.text '-h',:at=>[pdf.bounds.left + 220, pdf.bounds.bottom+340]
#		pdf.text '-i',:at=>[pdf.bounds.left + 220, pdf.bounds.bottom+345]
#		pdf.text '-j',:at=>[pdf.bounds.left + 220, pdf.bounds.bottom+355]
#		pdf.text '-k',:at=>[pdf.bounds.left + 220, pdf.bounds.bottom+260]
#		pdf.text '-l',:at=>[pdf.bounds.left + 220, pdf.bounds.bottom+265]
#		pdf.text '-m',:at=>[pdf.bounds.left + 220, pdf.bounds.bottom+270]
#		pdf.text '-n',:at=>[pdf.bounds.left + 220, pdf.bounds.bottom+275]
#		pdf.text '-o',:at=>[pdf.bounds.left + 220, pdf.bounds.bottom+280]
#		pdf.text '-p',:at=>[pdf.bounds.left + 220, pdf.bounds.bottom+285]
#		pdf.text '-q',:at=>[pdf.bounds.left + 220, pdf.bounds.bottom+290]
#		pdf.text '-r',:at=>[pdf.bounds.left + 220, pdf.bounds.bottom+295]

#    pdf.text 1,:at=>[pdf.bounds.left + 50, pdf.bounds.bottom+250]
#    pdf.text 2,:at=>[pdf.bounds.left + 100, pdf.bounds.bottom+250]
#    pdf.text 3,:at=>[pdf.bounds.left + 150, pdf.bounds.bottom+250]
#    pdf.text 4,:at=>[pdf.bounds.left + 200, pdf.bounds.bottom+250]
#    pdf.text 5,:at=>[pdf.bounds.left + 250, pdf.bounds.bottom+250]
#    pdf.text 6,:at=>[pdf.bounds.left + 300, pdf.bounds.bottom+250]
#    pdf.text 7,:at=>[pdf.bounds.left + 350, pdf.bounds.bottom+250]
#    pdf.text 8,:at=>[pdf.bounds.left + 400, pdf.bounds.bottom+250]
#    pdf.text 9,:at=>[pdf.bounds.left + 450, pdf.bounds.bottom+250]
#    pdf.text 0,:at=>[pdf.bounds.left + 500, pdf.bounds.bottom+250]
#    pdf.text 1,:at=>[pdf.bounds.left + 550, pdf.bounds.bottom+250]
	end # padded box
	pdf.move_down 25
	y-=pdf.bounds.height/2+25
end # for each copy holder
