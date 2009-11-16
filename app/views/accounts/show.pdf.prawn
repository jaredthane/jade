pdf.font_size = 20
	pdf.text "Estado de Cuentas de " + @account.name, :align => :center, :style => :bold
	pdf.text "Cliente Numero " + @account.entity.id.to_s, :align => :center
pdf.move_down 50
pdf.font_size = 12
current_line=675
current_line=printline("Saldo: ", @account.balance.to_s, 0, current_line,35,pdf)
current_line=printline("Rama: ", @account.parent.name.to_s, 0, current_line,35,pdf)
current_line=675
if @account.modifier==1
  current_line=printline("Tipo de Cuenta: ", 'Debito', 286, current_line,35,pdf)
else
  current_line=printline("Tipo de Cuenta: ", 'Credito', 286, current_line,35,pdf)
end


pdf.move_down 60
@entries_table=[]
x = Object.new.extend(ActionView::Helpers::NumberHelper)
for entry in @account.entries
	if entry.post.post_type_id==1
		@entries_table<< [entry.post.trans.created_at.to_date, entry.post.trans_id, entry.post.trans.description,entry.post.account.name, x.number_to_currency((entry.post.value||0)),'',x.number_to_currency((entry.balance||0))]
	else
		@entries_table<< [entry.post.trans.created_at.to_date, entry.post.trans_id, entry.post.trans.description,entry.post.account.name,'', x.number_to_currency((entry.post.value||0)),x.number_to_currency((entry.balance||0))]
	end
end
pdf.font_size = 14
	pdf.text "Transacciones recientes", :style => :bold
	pdf.table(@entries_table,
		 :font_size => 12,
		 :headers => ['Fecha', 'Transaccion', 'Tipo', 'Cuenta','Debito', 'Credito', 'Saldo'],
		 :horizontal_padding => 1,
		 :vertical_padding => 1,
		 :border_width => 1,
		 :border_style => :underline_header,
		 :column_widths => { 0 => 81, 1 => 81, 2 => 81, 3 => 108, 4 => 54, 5 => 54, 6 => 81},
		 :align => { 0 => :center,1 => :center, 2 => :center, 3 => :center, 4 => :center, 5 => :center, 6 => :center})
