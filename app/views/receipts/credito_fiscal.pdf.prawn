pdf.font_size = 10
o={:x=>30,:y=>0}
pdf.text @receipt.order.client.name, :at=>[85+o[:x],189+o[:y]]
pdf.text @receipt.order.client.address, :at=>[85+o[:x],179+o[:y]]
pdf.text @receipt.order.client.state.name, :at=>[95+o[:x],169+o[:y]]
#pdf.text "Efectivo", :at=>[135+o[:x],159+o[:y]]
pdf.text @receipt.order.client.city, :at=>[171+o[:x],169+o[:y]]
pdf.text @receipt.order.user.login, :at=>[250+o[:x],159+o[:y]]
pdf.text @receipt.order.created_at.to_date.to_s, :at=>[355+o[:x],189+o[:y]]
pdf.text @receipt.order.client.register, :at=>[355+o[:x],179+o[:y]]
pdf.text @receipt.order.client.nit, :at=>[355+o[:x],169+o[:y]]
pdf.text @receipt.order.client.giro, :at=>[355+o[:x],159+o[:y]]
pdf.bounding_box([35+o[:x],145+o[:y]], :width => 410, :height => 77) do
  pdf.table(@data,
				:at=>[35+o[:x],145+o[:y]],
	      :font_size => 9,
	      :horizontal_padding => 1,
	      :vertical_padding => 1,
	      :border_width => 0,
	      :align => { 0 => :center, 1 => :left, 2 => :center, 3 => :center, 4 => :center },
	      :widths => { 0 => 30, 1 => 275, 2 => 30, 3 => 25, 4 => 50})
end
pdf.text number_to_currency(@receipt.order.total_price), :at=>[405+o[:x],68+o[:y]]
pdf.text number_to_currency(@receipt.order.total_tax), :at=>[405+o[:x],54+o[:y]]
pdf.text number_to_currency(@receipt.order.total_price_with_tax), :at=>[405+o[:x],40+o[:y]]
pdf.text "$0.00", :at=>[405+o[:x],26+o[:y]]
pdf.text number_to_currency(@receipt.order.total_price_with_tax), :at=>[405+o[:x],16+o[:y]]
pdf.text @receipt.order.total_price_with_tax_in_spanish, :at=>[35+o[:x],68+o[:y]]
