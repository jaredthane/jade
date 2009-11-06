pdf.font_size = 20
if @entity.entity_type.id == 2 or @entity.entity_type.id == 5
	pdf.text "Detalles de " + @entity.name, :align => :center, :style => :bold
	pdf.text "Cliente Numero" + @entity.id.to_s, :align => :center
elsif @entity.entity_type.id == 3
	pdf.text "Detalles de " + @entity.name, :align => :center, :style => :bold
	pdf.text "Sitio Numero" + @entity.id.to_s, :align => :center
elsif @entity.entity_type.id == 1
	pdf.text "Detalles de " + @entity.name, :align => :center, :style => :bold
	pdf.text "Proveedor Numero" + @entity.id.to_s, :align => :center
end
pdf.move_down 40
current_line=675
pdf.font_size = 12
if @entity.entity_type.id == 2 or @entity.entity_type.id == 5
	current_line=printline("Fecha de Nacimiento: ", @entity.birth.to_date.to_s, 0, current_line,35,pdf)
end
if @entity.entity_type.id == 2 or @entity.entity_type.id == 5 or @entity.entity_type.id == 1
	current_line=printline("Direccion: ", @entity.address, 0, current_line,65,pdf)
	if @entity.state
		current_line=printline("Departamento: ", @entity.state.name, 0, current_line,35,pdf)
	end
	current_line=printline("Municipio: ", @entity.city, 0, current_line,35,pdf)
	current_line=printline("Notas: ", @entity.notes, 0, current_line,65,pdf)
end
if @entity.entity_type.id == 3
	if @entity.price_group
		current_line=printline("Grupo de Precios por Defecto: ", @entity.price_group.price_group_name.name, 0, current_line,35,pdf)
	end
	current_line=printline("Proxima Numero de Factura: ", @entity.next_receipt_number.to_s, 0, current_line,35,pdf)
end
if @entity.entity_type.id == 2 or @entity.entity_type.id == 5
	if @entity.user
		current_line=printline("Asesor: ", @entity.user.name, 0, current_line,35,pdf)
	end
	current_line=printline("Sitio: ", @entity.site.name, 0, current_line,35,pdf)
end
current_line=675
if @entity.entity_type
current_line=printline("Tipo: ", @entity.entity_type.name, 286, current_line,35,pdf)
end
if @entity.entity_type.id == 3
	if @entity.revenue_account
		current_line=printline("Cuenta de Ingresos: ", @entity.revenue_account.name, 286, current_line,35,pdf)
	end
	if @entity.expense_account
		current_line=printline("Cuenta de Gastos: ", @entity.expense_account.name, 286, current_line,35,pdf)
	end
	if @entity.tax_account
		current_line=printline("Cuenta de Impuestos: ", @entity.tax_account.name, 286, current_line,35,pdf)
	end
end
if @entity.entity_type.id == 2 or @entity.entity_type.id == 5 or @entity.entity_type.id == 1
	current_line=printline("Telefono Fijo: ", @entity.home_phone_number, 286, current_line,35,pdf)
	current_line=printline("Telefono Oficina: ", @entity.office_phone_number, 286, current_line,35,pdf)
	current_line=printline("Telefono Celular: ", @entity.cell_phone_number, 286, current_line,35,pdf)
	current_line=printline("Correo E: ", @entity.email, 286, current_line,35,pdf)
	if @entity.entity_type.id == 2 or @entity.entity_type.id == 5
		current_line=printline("Registro: ", @entity.register, 286, current_line,35,pdf)
		current_line=printline("NIT: ", @entity.nit, 286, current_line,35,pdf)
		current_line=printline("Giro: ", @entity.giro, 286, current_line,35,pdf)
		if User.current_user.has_rights(['Admin','View Subscriptions']) and @entity.subscription_day
			current_line=printline("Dia de Procesar Subscripciones: ", @entity.subscription_day.to_s, 286, current_line,35,pdf)
		end
	end
end
pdf.move_down 60
if @subs_table
	pdf.font_size = 14
	pdf.text "Suscripciones", :style => :bold
	pdf.table(@subs_table,
		 :font_size => 12,
		 :headers => ['Producto', 'Cantidad', 'Precio'],
		 :horizontal_padding => 1,
		 :vertical_padding => 1,
		 :border_width => 1,
		 :border_style => :underline_header,
		 :column_widths => { 0 => 180, 1 => 180, 2 => 180},
		 :align => { 0 => :center,1 => :center, 2 => :center})
end
pdf.move_down 30
if @entries_table
	pdf.font_size = 14
	pdf.text "Transacciones recientes", :style => :bold
	pdf.table(@entries_table,
		 :font_size => 12,
		 :headers => ['Fecha', 'Transaccion', 'Pedido', 'Debito', 'Credito', 'Saldo'],
		 :horizontal_padding => 1,
		 :vertical_padding => 1,
		 :border_width => 1,
		 :border_style => :underline_header,
		 :column_widths => { 0 => 90, 1 => 90, 2 => 90, 3 => 90, 4 => 90, 5 => 90},
		 :align => { 0 => :center,1 => :center, 2 => :center, 3 => :center, 4 => :center, 5 => :center})
end

