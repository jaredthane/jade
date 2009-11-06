pdf.font_size = 20
pdf.text "Detalles de Facturas Hechas Hoy", :align => :center, :style => :bold
pdf.font_size = 12
pdf.table(@data,
   :font_size => 12,
   :headers => ['Factura', 'Cliente', 'Fecha de Comienzo de Servicio','Precio', 'Cobrador'],
   :horizontal_padding => 1,
   :vertical_padding => 1,
   :border_width => 0,
   :border_style => :underline_header,
   :column_widths => { 0 => 100, 1 => 100, 2 => 100, 3 => 100, 4 => 100 },
   :align => { 0 => :center,1 => :center, 2 => :center,3 => :center,4 => :center })
   
 
