#o={:x=>30,:y=>0}
#pdf.text -10, :at=>[o[:x]+0,o[:y]+10]
#pdf.text -20, :at=>[o[:x]+0,o[:y]+20]
#pdf.text -30, :at=>[o[:x]+0,o[:y]+30]
#pdf.text -40, :at=>[o[:x]+0,o[:y]+40]
#pdf.text -50, :at=>[o[:x]+0,o[:y]+50]
#pdf.text -60, :at=>[o[:x]+0,o[:y]+60]
#pdf.text -70, :at=>[o[:x]+0,o[:y]+70]
#pdf.text -80, :at=>[o[:x]+0,o[:y]+80]
#pdf.text -90, :at=>[o[:x]+0,o[:y]+90]
#pdf.text -100, :at=>[o[:x]+0,o[:y]+100]
#pdf.text -110, :at=>[o[:x]+0,o[:y]+110]
#pdf.text -120, :at=>[o[:x]+0,o[:y]+120]
#pdf.text -130, :at=>[o[:x]+0,o[:y]+130]
#pdf.text -140, :at=>[o[:x]+0,o[:y]+140]
#pdf.text -150, :at=>[o[:x]+0,o[:y]+150]
#pdf.text -160, :at=>[o[:x]+0,o[:y]+160]
#pdf.text -170, :at=>[o[:x]+0,o[:y]+270]
#pdf.text -180, :at=>[o[:x]+0,o[:y]+180]
#pdf.text -190, :at=>[o[:x]+0,o[:y]+190]
#pdf.text -200, :at=>[o[:x]+0,o[:y]+200]
#pdf.text -220, :at=>[o[:x]+0,o[:y]+220]
#pdf.text -240, :at=>[o[:x]+0,o[:y]+240]
#pdf.text -260, :at=>[o[:x]+0,o[:y]+260]
#pdf.text -280, :at=>[o[:x]+0,o[:y]+280]
#pdf.text -300, :at=>[o[:x]+0,o[:y]+300]
#pdf.text -320, :at=>[o[:x]+0,o[:y]+320]
#pdf.text -340, :at=>[o[:x]+0,o[:y]+340]
#pdf.text -360, :at=>[o[:x]+0,o[:y]+360]
#pdf.text -380, :at=>[o[:x]+0,o[:y]+380]
#pdf.text -400, :at=>[o[:x]+0,o[:y]+400]
#pdf.text -420, :at=>[o[:x]+0,o[:y]+420]
#pdf.text -440, :at=>[o[:x]+0,o[:y]+440]
#pdf.text -460, :at=>[o[:x]+0,o[:y]+460]
#pdf.text -480, :at=>[o[:x]+0,o[:y]+480]
#pdf.text -500, :at=>[o[:x]+0,o[:y]+500]



#pdf.text 1, :at =>[10,10]
#pdf.text 2, :at =>[20,10]
#pdf.text 3, :at =>[30,10]
#pdf.text 4, :at =>[40,10]
#pdf.text 5, :at =>[50,10]
#pdf.text 6, :at =>[60,10]
#pdf.text 7, :at =>[70,10]
#pdf.text 8, :at =>[80,10]
#pdf.text 9, :at =>[90,10]
#pdf.text 0, :at =>[100,10]
#pdf.text 1, :at =>[110,10]
#pdf.text 2, :at =>[120,10]
#pdf.text 3, :at =>[130,10]
#pdf.text 4, :at =>[140,10]
#pdf.text 5, :at =>[150,10]
#pdf.text 6, :at =>[160,10]
#pdf.text 7, :at =>[270,10]
#pdf.text 8, :at =>[180,10]
#pdf.text 9, :at =>[190,10]
#pdf.text 0, :at =>[200,10]
#pdf.text 2, :at =>[220,10]
#pdf.text 4, :at =>[240,10]
#pdf.text 6, :at =>[260,10]
#pdf.text 8, :at =>[280,10]
#pdf.text 0, :at =>[300,10]


if @receipt.client.entity_type.id == 2	# for final consumers
	pdf.font.size = 9
	o={:x=>-10,:y=>0}
	pdf.text @receipt.client.name, :at=>[90+o[:x],310+o[:y]]
	pdf.text @receipt.client.address, :at=>[100+o[:x],308+o[:y]]
	pdf.text @receipt.created_at.to_date.to_s, :at=>[220+o[:x],325+o[:y]]
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
	pdf.text number_to_currency(@receipt.total_price), :at=>[283+o[:x],50+o[:y]]
	pdf.text "$0.00", :at=>[285+o[:x],30+o[:y]]
	pdf.text number_to_currency(@receipt.total_price_with_tax), :at=>[283+o[:x],20+o[:y]]
else
	pdf.font.size = 10
	o={:x=>30,:y=>0}
	pdf.text @receipt.client.name, :at=>[85+o[:x],189+o[:y]]
	pdf.text @receipt.client.address, :at=>[85+o[:x],179+o[:y]]
	pdf.text @receipt.client.state.name, :at=>[95+o[:x],169+o[:y]]
	#pdf.text "Efectivo", :at=>[135+o[:x],159+o[:y]]
	pdf.text @receipt.client.city, :at=>[171+o[:x],169+o[:y]]
	pdf.text @receipt.user.login, :at=>[250+o[:x],159+o[:y]]
	pdf.text @receipt.created_at.to_date.to_s, :at=>[355+o[:x],189+o[:y]]
	pdf.text @receipt.client.register, :at=>[355+o[:x],179+o[:y]]
	pdf.text @receipt.client.nit, :at=>[355+o[:x],169+o[:y]]
	pdf.text @receipt.client.giro, :at=>[355+o[:x],159+o[:y]]
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
	pdf.text number_to_currency(@receipt.total_price), :at=>[405+o[:x],68+o[:y]]
	pdf.text number_to_currency(@receipt.total_tax), :at=>[405+o[:x],54+o[:y]]
	pdf.text number_to_currency(@receipt.total_price_with_tax), :at=>[405+o[:x],40+o[:y]]
	pdf.text "$0.00", :at=>[405+o[:x],26+o[:y]]
	pdf.text number_to_currency(@receipt.total_price_with_tax), :at=>[405+o[:x],16+o[:y]]
end
