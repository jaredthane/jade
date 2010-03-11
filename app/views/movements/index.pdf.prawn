for product,list in @movements
  pdf.start_new_page(:layout => :landscape)
  pdf.font_size = 20
  pdf.text "Movimientos de " + product.name, :align => :center, :style => :bold
  pdf.font_size = 10
  pdf.text COMPANY_NAME, :align => :center
  if @till != @from
	  pdf.text "#{@from.to_date} - #{@till.to_date}", :align => :center
  else
	  pdf.text "#{@till.to_date}", :align => :center
  end
  pdf.font_size = 8
  pdf.text "NIT:" + @site.nit_number, :align => :center if @site.nit
  pdf.text "Registro:" + @site.register, :align => :center if @site.register
  pdf.text @site.giro, :align => :center if @site.giro
  data=[]
  total={}
  value={}
  list.reverse!
  for m in list   
    total[m.product] = m.product.quantity(@site) if !total.has_key?(m.product)
    if !value.has_key?(m.product)
      value[m.product] = m.product.total_value_of_inventory(@site) 
      puts "m.product.total_value_of_inventory(@site)=#{m.product.total_value_of_inventory(@site).to_s}"
    end
    case m.movement_type_id
    when Movement::SALE
      if m.quantity <0
        #               'ID',       'Fecha',              'No. Doc',            'Entidad',         'Nacionalidad',      'Referencia',     'Precio Unitario Entrada',                'Precio Unitario Salida',                      'Entrada',     'Salida',          'Existencias',         'Debe',                            'Haber',                       'Saldo'
    	  data.unshift([m.id, m.created_at.to_date, m.order.receipt_number, m.order.client.name, m.order.client.country, "l. de ventas",          "",                             number_to_currency(-(m.cost||0)/m.quantity),            "",       -(m.quantity||0),    total[m.product],      "",                      number_to_currency((m.cost||0)), number_to_currency(value[m.product])])
    	else
    	  data.unshift([m.id, m.created_at.to_date, m.order.receipt_number, m.order.client.name, m.order.client.country, "l. de ventas-",  number_to_currency((m.cost||0)/m.quantity),        "",                                 (m.quantity||0),      "",           total[m.product],    number_to_currency((m.cost||0)),       "",                     number_to_currency(value[m.product])])
    	end
      value[m.product] = (value.has_key?(m.product) ? value[m.product] + (m.cost||0) : (m.cost||0))
    when Movement::PURCHASE
       if m.quantity >0
        data.unshift([m.id, m.created_at.to_date, m.order.receipt_number, m.order.vendor.name, m.order.vendor.country, "l. de compras", number_to_currency((m.cost||0)/m.quantity), "",   m.quantity, "", total[m.product],number_to_currency(m.cost),"",  number_to_currency(value[m.product])])
    	else
    	  data.unshift([m.id, m.created_at.to_date, m.order.receipt_number, m.order.vendor.name, m.order.vendor.country, "l. de compras-", "", number_to_currency(-(m.cost||0)/m.quantity), "",  -(m.quantity||0), total[m.product],"", number_to_currency(-(m.cost||0)), number_to_currency(value[m.product])])    	  
    	end
      value[m.product] = (value.has_key?(m.product) ? value[m.product] - (m.cost||0) : (m.cost||0))
    when Movement::COUNT
       if m.quantity >0
        data.unshift([m.id, m.created_at.to_date, "", "", "", "inventario", number_to_currency((m.cost||0)/m.quantity), "",   m.quantity, "", total[m.product],number_to_currency(m.cost),"",  number_to_currency(value[m.product])])
    	else
    	  data.unshift([m.id, m.created_at.to_date, "", "", "",  "inventario-", number_to_currency(-(m.cost||0)/m.quantity), "", "",  -(m.quantity||0), total[m.product],"", number_to_currency(-(m.cost||0)), number_to_currency(value[m.product])])    	  
    	end
      value[m.product] = (value.has_key?(m.product) ? value[m.product] - (m.cost||0) : (m.cost||0))
    end
    total[m.product] = (total.has_key?(m.product) ? total[m.product] - m.quantity : m.product.quantity(@site))
  end
  width=pdf.bounds.width

  if data.length>0
	  pdf.table(data,
		  :font_size => 8,
		  :align => { 0 => :center, 1 => :left, 2 => :center, 3 => :center, 4 => :center, 5 => :center ,     6 => :center,             7 => :center,          8 => :center, 9 => :center, 10 => :center, 11 => :center, 12 => :center, 13 => :center},
		  :headers => ['',       'Fecha',    'No. Doc',    'Entidad',  'Nacionalidad',  'Referencia',  'Precio Unitario Entrada','Precio Unitario Salida',  'Entrada',  'Salida',   'Existencias',     'Debe',        'Haber',      'Saldo'],
		  :border_style => :grid,
		  :column_widths => { 0 => 0.04*width, 1 => 0.07*width, 2 => 0.06*width, 3 => 0.18*width, 4 => 0.07*width, 5 => 0.06*width, 6 => 0.06*width, 7 => 0.06*width, 8 => 0.06*width, 9 => 0.06*width, 10 => 0.06*width, 11 => 0.06*width, 12 => 0.06*width, 13 => 0.08*width})
  else
	  pdf.font_size = 10
	  pdf.text "No hubieron ningunos movimientos en las fechas specificadas.", :align => :center, :style => :bold
  end
  pdf.font_size = 8
  pdf.number_pages "Pagina <page> de <total>", [pdf.bounds.right-50, 0]
end
