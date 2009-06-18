pdf.font_size = 15
pdf.text "Corte de Caja en " + @site.name, :align => :center, :style => :bold
pdf.text "Servicable, S. A. de C. V.", :align => :center, :style => :bold
pdf.text @from.to_date.to_s(:long) + " - " + @till.to_date.to_s(:long), :align => :center, :style => :bold

pdf.font_size = 12
pdf.table(@data,
   :font_size => 12,
   :headers => ['Asesor', 'Saldo Anterior', 'Facturas','Saldo Provisionado','Pagos','Saldo Cobrado','Saldo Final'],
   :horizontal_padding => 1,
   :vertical_padding => 1,
   :border_width => 0,
   :border_style => :underline_header,
   :column_widths => { 0 => 80, 1 => 70, 2 => 70, 3 => 70, 4 => 70, 5 => 70, 6 => 70 },
   :align => { 0 => :left,1 => :left, 2 => :left,3 => :left,4 => :left,5 => :left,6 => :left })
   
 
