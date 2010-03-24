pdf.font_size = 15
pdf.text "Corte de Caja en " + @site.name, :align => :center, :style => :bold
pdf.text COMPANY_NAME, :align => :center, :style => :bold
pdf.text @from.to_date.to_s(:long) + " - " + @till.to_date.to_s(:long), :align => :center, :style => :bold

pdf.font_size = 12
pdf.text "  "
pdf.text "Corte de Caja", :align => :center, :style => :bold

@box=[]
@box << ['Asesor', 'Saldo']
for rep in @reps
	@box<<[rep[:user].name, '']
end
@box<<['Total', '']
pdf.table(@box,
	 :font_size => 12,
   :horizontal_padding => 1,
   :vertical_padding => 1,
   :border_width => 1,
   :border_style => :grid,
   :column_widths => { 0 => 430, 1 => 140},
   :align => { 0 => :left,1 => :center})

@data=[]
@data << ['',{:text => 'Anterior', :colspan => 2}, {:text => 'Actual', :colspan => 4}, {:text => 'Pendiente', :colspan => 2}]
@data << ['Asesor', 'Saldo', 'Facturas','Provisionado','Facturas','Pagado','Pagos','Saldo','Facturas']
total={:previous_balance=>0, :previous_orders=>0, :current_orders_count=>0, :current_orders_total=>0, :current_payments_count=>0, :current_payments_total=>0, :orders_pending=>0, :balance_pending=>0}
x = Object.new.extend(ActionView::Helpers::NumberHelper)
for rep in @reps
	previous_orders = rep[:previous_orders_count]-rep[:previous_payments_count]
	previous_balance = rep[:previous_orders_total]-rep[:previous_payments_total]
	orders_pending = rep[:previous_orders_count]-rep[:previous_payments_count] + rep[:current_orders_count]-rep[:current_payments_count]
	balance_pending = rep[:previous_orders_total]-rep[:previous_payments_total] + rep[:current_orders_total]-rep[:current_payments_total]
@data << [rep[:user].name, 
	previous_orders, 
	number_to_currency(previous_balance), 
	rep[:current_orders_count], 
	rep[:current_orders_total], 
	rep[:current_payments_count], 
	rep[:current_payments_total], 
	orders_pending, 
	x.number_to_currency(balance_pending)]
	
total[:previous_orders]+=rep[:previous_orders]
total[:previous_balance]+=rep[:previous_balance]
total[:current_orders_count]+=rep[:current_orders_count]
total[:current_orders_total]+=rep[:current_orders_total]
total[:current_payments_count]+=rep[:current_payments_count]
total[:current_payments_total]+=rep[:current_payments_total]
total[:orders_pending]+=rep[:orders_pending]
total[:balance_pending]+=rep[:balance_pending]
end
#		@data << ["---", "---", "---", "---", "---", "---", "---"]
@data << ["Totales", 
total[:num_receipts], 
total[:num_payments], 
rep[:facturas_pendientes], 
x.number_to_currency(total[:previous_balance]), 
x.number_to_currency(total[:revenue]), 
x.number_to_currency(total[:cash_received]), 
x.number_to_currency(total[:final_balance])]




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
   
 
