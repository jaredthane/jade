pdf.font_size = 15
pdf.text "Corte de Caja en " + @site.name, :align => :center, :style => :bold
pdf.text "Servicable, S. A. de C. V.", :align => :center, :style => :bold
pdf.text @from.to_date.to_s(:long) + " - " + @till.to_date.to_s(:long), :align => :center, :style => :bold

pdf.font_size = 12
pdf.text "  "
pdf.text "Corte de Caja", :align => :center, :style => :bold
pdf.table(@box,
	 :font_size => 12,
   :horizontal_padding => 1,
   :vertical_padding => 1,
   :border_width => 1,
   :border_style => :grid,
   :column_widths => { 0 => 430, 1 => 140},
   :align => { 0 => :left,1 => :center})

pdf.text "  "
pdf.text "Cuentas por cobrar", :align => :center, :style => :bold
pdf.table(@data,
   :font_size => 12,
   :horizontal_padding => 1,
   :vertical_padding => 1,
   :border_width => 1,
   :border_style => :grid,
   :column_widths => { 0 => 80, 1 => 70, 2 => 70, 3 => 70, 4 => 70, 5 => 70, 6 => 70, 7 => 70 },
   :align => { 0 => :center,1 => :center, 2 => :center,3 => :center,4 => :center,5 => :center,6 => :center,7 => :center })
   
 
