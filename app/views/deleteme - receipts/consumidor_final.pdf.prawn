pdf.start_new_page(:size => 'LEGAL')
	# 612.00x 1008.00, that leaves 612.00x336 when divided into 3 parts
	#540.0
	#936.0
	#class page(pdf)
	#	self.top=pdf.bounds.top
	#	self.bottom=pdf.bounds.bottom
	#	self.left=pdf.bounds.left
	#	self.right=pdf.bounds.right
	#end
	#class box(x,y,h,w, parent)
	#	self.top=x+(parent.left||0)
	#	self.top=y+(parent.top||0)
	#end
	y=936
	#pdf.text pdf.bounds.width
	#pdf.text pdf.bounds.height
	for copy in ['cliente', 'vendor', 'government'] do
#		pdf.stroke_bounds
		pdf.bounding_box([0,y], :width=>540, :height=>312) do
			# Put the companies contact information in the top-left corner
			pdf.bounding_box([0, 312], :width=>350, :height=>120) do
#				pdf.stroke_bounds
				pdf.move_down 5
				pdf.font_size = 14
				pdf.text COMPANY_NAME
				pdf.font_size = 10
				pdf.text @receipt.order.vendor.address
				if @receipt.order.vendor.office_phone
					pdf.text "Telefono: " + @receipt.order.vendor.office_phone
				end
				if @receipt.order.vendor.email
					pdf.text "Correo Electronico: " + @receipt.order.vendor.email
				end
			end
			# Put the client information in the top-right corner
			pdf.bounding_box([350, 312], :width=>540-350, :height=>120) do
#				pdf.stroke_bounds
				pdf.move_down 30
				pdf.font_size = 12
				pdf.text "Cliente: " + @receipt.order.client.name
				pdf.font_size = 10
				pdf.text @receipt.order.client.address
				if @receipt.order.vendor.home_phone
					pdf.text "Telefono Fijo: " + @receipt.order.client.home_phone
				end
				if @receipt.order.vendor.office_phone
					pdf.text "Telefono Oficina: " + @receipt.order.client.office_phone
				end
				if @receipt.order.vendor.office_phone
					pdf.text "Telefono Celular: " + @receipt.order.client.cell_phone
				end
				if @receipt.order.vendor.email
					pdf.text "Correo Electronico: " + @receipt.order.client.email
				end
			end
			pdf.stroke_horizontal_rule

			pdf.move_down 10
			width=pdf.bounds.width
			# Poner tabla de productos
		  data=[]
			total=0
			for l in @receipt.lines
				x = Object.new.extend(ActionView::Helpers::NumberHelper)
				if l.product.serialized
					if l.serialized_product
						data << [l.quantity.to_s, l.product.name + " - " + l.serialized_product.serial_number, x.number_to_currency(l.price), "", x.number_to_currency(l.total_price)]
					end
				else
					data << [l.quantity.to_s, l.product.name, x.number_to_currency(l.price),  x.number_to_currency(l.total_price),""]
				end
				total += l.total_price
			end  
			pdf.table(data,
					:at=>[0,pdf.cursor],
		      :font_size => 12,
		      :horizontal_padding => 1,
		      :vertical_padding => 1,
		      :border_width => 1,
		      :align => { 0 => :center, 1 => :left, 2 => :center, 3 => :center },
		      :headers => ['Cantidad', 'Producto', 'Unidad','Total'],
		      :column_widths => { 0 => 0.1*width, 1 => 0.7*width, 2 => 0.1*width, 3 => 0.1*width})	  
		end
		y-=312
	end
	#pdf.bounding_box [100,600], :width => 200 do
	#    pdf.move_down 10
	#    pdf.text "The rain in spain falls mainly on the plains " * 5
	#    pdf.move_down 20
	#    pdf.stroke do
	#      pdf.line pdf.bounds.top_left,    pdf.bounds.top_right
	#      pdf.line pdf.bounds.bottom_left, pdf.bounds.bottom_right
	#    end
	#  end
	#    pdf.move_down 10
	#    pdf.text "The rain in spain falls mainly on the plains " * 5
	#    pdf.move_down 20
	#    pdf.stroke do
	#      pdf.line pdf.bounds.top_left,    pdf.bounds.top_right
	#      pdf.line pdf.bounds.bottom_left, pdf.bounds.bottom_right
	#    end
	#pdf.font_size = 12
	#o={:x=>0,:y=>0}
	#pdf.text @receipt.order.client.name, :at=>[110+o[:x],320+o[:y]]
	#pdf.text @receipt.order.client.address, :at=>[220+o[:x],320+o[:y]]
	#pdf.text @receipt.order.created_at.to_date.to_s(:long), :at=>[65+o[:x],340+o[:y]]
	#pdf.bounding_box([30+o[:x],200+o[:y]], :width => 540, :height => 60) do
	#  pdf.table(@data,
	#				:at=>[30+o[:x],200+o[:y]],
	#	      :font_size => 12,
	#	      :horizontal_padding => 1,
	#	      :vertical_padding => 1,
	#	      :border_width => 1,
	#	      :align => { 0 => :center, 1 => :left, 2 => :center, 3 => :center, 4 => :center },
	#	      :column_widths => { 0 => 45, 1 => 305, 2 => 55, 3 => 65, 4 => 65})
	#end
	#pdf.text number_to_currency(@receipt.total_price), :at=>[510+o[:x],105+o[:y]]
	#pdf.text "$0.00", :at=>[510+o[:x],95+o[:y]]
	#pdf.text number_to_currency(@receipt.total_price_with_tax), :at=>[510+o[:x],40+o[:y]]
	#pdf.text "x offset="+o[:x].to_s, :at => [50,40]
	#pdf.text "y offset="+o[:y].to_s, :at => [50,30]
	#pdf.text -10, :at=>[o[:x]+10,o[:y]+10]
	#pdf.text -20, :at=>[o[:x]+10,o[:y]+20]
	#pdf.text -30, :at=>[o[:x]+10,o[:y]+30]
	#pdf.text -40, :at=>[o[:x]+10,o[:y]+40]
	#pdf.text -50, :at=>[o[:x]+10,o[:y]+50]
	#pdf.text -60, :at=>[o[:x]+10,o[:y]+60]
	#pdf.text -70, :at=>[o[:x]+10,o[:y]+70]
	#pdf.text -80, :at=>[o[:x]+10,o[:y]+80]
	#pdf.text -90, :at=>[o[:x]+10,o[:y]+90]
	#pdf.text -100, :at=>[o[:x]+10,o[:y]+100]
	#pdf.text -110, :at=>[o[:x]+10,o[:y]+110]
	#pdf.text -120, :at=>[o[:x]+10,o[:y]+120]
	#pdf.text -130, :at=>[o[:x]+10,o[:y]+130]
	#pdf.text -140, :at=>[o[:x]+10,o[:y]+140]
	#pdf.text -150, :at=>[o[:x]+10,o[:y]+150]
	#pdf.text -160, :at=>[o[:x]+10,o[:y]+160]
	#pdf.text -170, :at=>[o[:x]+10,o[:y]+270]
	#pdf.text -180, :at=>[o[:x]+10,o[:y]+180]
	#pdf.text -190, :at=>[o[:x]+10,o[:y]+190]
	#pdf.text -200, :at=>[o[:x]+10,o[:y]+200]
	#pdf.text -220, :at=>[o[:x]+10,o[:y]+220]
	#pdf.text -240, :at=>[o[:x]+10,o[:y]+240]
	#pdf.text -260, :at=>[o[:x]+10,o[:y]+260]
	#pdf.text -280, :at=>[o[:x]+10,o[:y]+280]
	#pdf.text -300, :at=>[o[:x]+10,o[:y]+300]
	#pdf.text -320, :at=>[o[:x]+10,o[:y]+320]
	#pdf.text -340, :at=>[o[:x]+10,o[:y]+340]
	#pdf.text -360, :at=>[o[:x]+10,o[:y]+360]
	#pdf.text -380, :at=>[o[:x]+10,o[:y]+380]
	#pdf.text -400, :at=>[o[:x]+10,o[:y]+400]
	#pdf.text -420, :at=>[o[:x]+10,o[:y]+420]
	#pdf.text -440, :at=>[o[:x]+10,o[:y]+440]
	#pdf.text -460, :at=>[o[:x]+10,o[:y]+460]
	#pdf.text -480, :at=>[o[:x]+10,o[:y]+480]
	#pdf.text -500, :at=>[o[:x]+10,o[:y]+500]
	#pdf.text -520, :at=>[o[:x]+10,o[:y]+520]
	#pdf.text -540, :at=>[o[:x]+10,o[:y]+540]
	#pdf.text -560, :at=>[o[:x]+10,o[:y]+560]
	#pdf.text -580, :at=>[o[:x]+10,o[:y]+580]
	#pdf.text -600, :at=>[o[:x]+10,o[:y]+600]
	#pdf.text -620, :at=>[o[:x]+10,o[:y]+620]
	#pdf.text -640, :at=>[o[:x]+10,o[:y]+640]
	#pdf.text -660, :at=>[o[:x]+10,o[:y]+660]
	#pdf.text -680, :at=>[o[:x]+10,o[:y]+680]
	#pdf.text -700, :at=>[o[:x]+10,o[:y]+700]
	#pdf.text -720, :at=>[o[:x]+10,o[:y]+720]
	#pdf.text -740, :at=>[o[:x]+10,o[:y]+740]
	#pdf.text -760, :at=>[o[:x]+10,o[:y]+760]
	#pdf.text -780, :at=>[o[:x]+10,o[:y]+780]
	#pdf.text -800, :at=>[o[:x]+10,o[:y]+800]


	#pdf.text "|", :at =>[0,170]
	#pdf.text 1, :at =>[100,170]
	#text 2, :at =>[200,170]
	#text 3, :at =>[300,170]
	#text 4, :at =>[400,170]
	#text 5, :at =>[500,170]

	#text 1, :at =>[-10,160]
	#text 2, :at =>[-20,160]
	#text 3, :at =>[-30,160]
	#text 4, :at =>[-40,160]
	#text 5, :at =>[-50,160]
	#text 6, :at =>[-60,160]
	#text 7, :at =>[-70,160]
	#text 8, :at =>[-80,160]
	#text 9, :at =>[-90,160]
	#text 0, :at =>[-100,160]

	#text 0, :at =>[0,160]
	#text 1, :at =>[10,160]
	#text 2, :at =>[20,160]
	#text 3, :at =>[30,160]
	#text 4, :at =>[40,160]
	#text 5, :at =>[50,160]
	#text 6, :at =>[60,160]
	#text 7, :at =>[70,160]
	#text 8, :at =>[80,160]
	#text 9, :at =>[90,160]
	#text 0, :at =>[100,160]
	#text 1, :at =>[110,160]
	#text 2, :at =>[120,160]
	#text 3, :at =>[130,160]
	#text 4, :at =>[140,160]
	#text 5, :at =>[150,160]
	#text 6, :at =>[160,160]
	#text 7, :at =>[270,160]
	#text 8, :at =>[180,160]
	#text 9, :at =>[190,160]
	#pdf.text 0, :at =>[200,160]
	#pdf.text 2, :at =>[220,160]
	#pdf.text 4, :at =>[240,160]
	#pdf.text 6, :at =>[260,160]
	#pdf.text 8, :at =>[280,160]
	#pdf.text 0, :at =>[300,160]
	#pdf.text 2, :at =>[320,160]
	#pdf.text 4, :at =>[340,160]
	#pdf.text 6, :at =>[360,160]
	#pdf.text 8, :at =>[380,160]
	#pdf.text 0, :at =>[400,160]
	#pdf.text 2, :at =>[420,160]
	#pdf.text 4, :at =>[440,160]
	#pdf.text 6, :at =>[460,160]
	#pdf.text 8, :at =>[480,160]
	#pdf.text 0, :at =>[500,160]


