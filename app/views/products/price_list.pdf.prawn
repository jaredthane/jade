pdf.font_size = 20
pdf.text "Lista de Precios", :align => :center   
pdf.font_size = 12
  pdf.table(@data,
	      :font_size => 12,
	      :headers => ['Nombre', 'Descripcion', 'Precio'],
	      :horizontal_padding => 1,
	      :vertical_padding => 1,
	      :border_width => 0,
	      :column_widths => { 0 => 125, 1 => 375, 2 => 50 },
	      :align => { 0 => :left, 1 => :left, 2 => :right })
