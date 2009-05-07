pdf.font_size = 9
o={:x=>-10,:y=>10}
pdf.text @order.client.name, :at=>[90+o[:x],310+o[:y]]
pdf.text @order.client.address, :at=>[100+o[:x],308+o[:y]]
pdf.text @order.created_at.to_date.to_s, :at=>[220+o[:x],325+o[:y]]
pdf.bounding_box([60+o[:x],270+o[:y]], :width => 255, :height => 220) do
  pdf.table(@data,
				:at=>[60+o[:x],270+o[:y]],
	      :font_size => 9,
	      :horizontal_padding => 1,
	      :vertical_padding => 1,
	      :border_width => 0,
	      :align => { 0 => :center, 1 => :left, 2 => :center, 3 => :center, 4 => :center },
	      :widths => { 0 => 30, 1 => 130, 2 => 35, 3 => 25, 4 => 35})
end
pdf.text number_to_currency(@order.total_price), :at=>[283+o[:x],50+o[:y]]
pdf.text "$0.00", :at=>[285+o[:x],30+o[:y]]
pdf.text number_to_currency(@order.total_price_with_tax), :at=>[283+o[:x],20+o[:y]]
