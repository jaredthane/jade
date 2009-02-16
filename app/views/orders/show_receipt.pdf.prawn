pdf.font.size = 10
o={:x=>30,:y=>-10}
pdf.text @receipt.client.name, :at=>[85+o[:x],189+o[:y]]
pdf.text @receipt.client.address, :at=>[85+o[:x],179+o[:y]]
pdf.text @receipt.client.state.name, :at=>[95+o[:x],169+o[:y]]
pdf.text "Efectivo", :at=>[135+o[:x],159+o[:y]]
pdf.text @receipt.client.city, :at=>[171+o[:x],169+o[:y]]
pdf.text @receipt.user.login, :at=>[250+o[:x],159+o[:y]]
pdf.text @receipt.created_at.to_date.to_s, :at=>[355+o[:x],189+o[:y]]
pdf.text @receipt.client.register, :at=>[355+o[:x],179+o[:y]]
pdf.text @receipt.client.nit, :at=>[355+o[:x],169+o[:y]]
pdf.text @receipt.client.giro, :at=>[355+o[:x],159+o[:y]]
pdf.bounding_box([35+o[:x],145+o[:y]], :width => 400, :height => 77) do
pdf.table(@data,
					:at=>[35+o[:x],145+o[:y]],
	        :font_size => 10,
	        :horizontal_padding => 5,
	        :vertical_padding => 1,
	        :border_width => 0,
	        :widths => { 0 => 30, 1 => 275, 2 => 35, 3 => 30, 4 => 30})
end
pdf.text number_to_currency(@receipt.total_price), :at=>[405+o[:x],68+o[:y]]
pdf.text number_to_currency(@receipt.total_tax), :at=>[405+o[:x],54+o[:y]]
pdf.text number_to_currency(@receipt.total_price_with_tax), :at=>[405+o[:x],40+o[:y]]
pdf.text "$0.00", :at=>[405+o[:x],26+o[:y]]
pdf.text number_to_currency(@receipt.total_price_with_tax), :at=>[405+o[:x],12+o[:y]]

