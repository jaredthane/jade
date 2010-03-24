pdf.font_size = 20
	pdf.text "Estado de Cuentas de '" + @account.name + "'", :align => :center, :style => :bold
	if @account.entity
  	pdf.text "Cliente Numero " + @account.entity.id.to_s, :align => :center
  end
pdf.move_down 50
pdf.font_size = 12
x = Object.new.extend(ActionView::Helpers::NumberHelper)
current_line=675
if !@account.is_parent
	current_line=printline("Saldo: ", x.number_to_currency(@account.balance), 0, current_line,35,pdf)
end
if @account.parent
  current_line=printline("Rama: ", @account.parent.name.to_s, 0, current_line,35,pdf)
end
current_line=675
if @account.modifier==1
  current_line=printline("Tipo de Cuenta: ", 'Debito', 286, current_line,35,pdf)
else
  current_line=printline("Tipo de Cuenta: ", 'Credito', 286, current_line,35,pdf)
end

if @account.is_parent
	pdf.move_down 60
	@accounts_table=[]
	for account in @account.all_children
		if !account.is_parent
			t=account.modifier==1 ? 'Debe' : 'Haber'
			@accounts_table<< [account.number, account.name, t,x.number_to_currency((account.balance||0))]
		end
	end
	pdf.font_size = 14
		pdf.text "Cuentas en esta rama:", :style => :bold
		pdf.table(@accounts_table,
			 :font_size => 12,
			 :headers => ['Numero', 'Nombre', 'Tipo', 'Saldo'],
			 :horizontal_padding => 1,
			 :vertical_padding => 1,
			 :border_width => 1,
			 :border_style => :underline_header,
			 :column_widths => { 0 => 100, 1 => 300, 2 => 100, 3 => 100},
			 :align => { 0 => :center,1 => :center, 2 => :center, 3 => :center})
else
	pdf.move_down 60
	@posts_table=[]
	for post in @account.recent_posts
		if post.trans.order
		  if post.trans.order.received
		    received = (post.trans.order.received.to_date||'')
		   else
		    received = post.trans.created_at.to_date
		   end
		  number=post.trans.order.receipt_number
		else
		  received = post.trans.created_at.to_date
		  number=""
		end
		
		if post.post_type_id==1
			@posts_table<< [received, number, post.trans.description,post.account.name, x.number_to_currency((post.value||0)),'',x.number_to_currency((post.balance||0))]
		else
			@posts_table<< [received, number, post.trans.description,post.account.name,'', x.number_to_currency((post.value||0)),x.number_to_currency((post.balance||0))]
		end
	end
	pdf.font_size = 14
	pdf.text "Transacciones recientes", :style => :bold
	if @posts_table.length > 0
		pdf.table(@posts_table,
			 :font_size => 12,
			 :headers => ['Fecha', 'Factura', 'Tipo', 'Cuenta','Debito', 'Credito', 'Saldo'],
			 :horizontal_padding => 1,
			 :vertical_padding => 1,
			 :border_width => 1,
			 :border_style => :underline_header,
			 :column_widths => { 0 => 81, 1 => 81, 2 => 81, 3 => 108, 4 => 54, 5 => 54, 6 => 81},
			 :align => { 0 => :center,1 => :center, 2 => :center, 3 => :center, 4 => :center, 5 => :center, 6 => :center})
	else
		pdf.move_down 60
		pdf.text "No hay ningunas transacciones para mostrar."
	end
end
