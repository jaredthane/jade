pdf.font_size = 20
pdf.text "Lista de Precios", :align => :center, :style => :bold
pdf.font_size = 12
  pdf.table(@data,
	      :font_size => 12,
	      :headers => ['Descripcion', 'Precio'],
	      :horizontal_padding => 1,
	      :vertical_padding => 1,
	      :border_width => 0,
	      :border_style => :underline_header,
	      :column_widths => { 0 => 500, 1 => 50 },
	      :align => { 0 => :left, 1 => :right })
