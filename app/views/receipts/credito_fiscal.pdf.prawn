pdf.font_size = 12
o={:x=>30,:y=>30}
pdf.text @receipt.order.client.name, :at=>[75+o[:x],670+o[:y]]
pdf.text @receipt.order.client.address, :at=>[75+o[:x],660+o[:y]]
pdf.text @receipt.order.client.state.name, :at=>[320+o[:x],643+o[:y]]
pdf.text "Efectivo", :at=>[125+o[:x],630+o[:y]]
pdf.text @receipt.order.client.city, :at=>[75+o[:x],643+o[:y]]
#pdf.text @receipt.order.user.login, :at=>[250+o[:x],159+o[:y]]
pdf.text @receipt.order.created_at.to_date.to_s(:long), :at=>[420+o[:x],660+o[:y]]
pdf.text @receipt.order.client.register, :at=>[300+o[:x],630+o[:y]]
pdf.text @receipt.order.client.nit, :at=>[440+o[:x],643+o[:y]]
pdf.text @receipt.order.client.giro, :at=>[440+o[:x],630+o[:y]]
pdf.bounding_box([30+o[:x],595+o[:y]], :width => 540, :height => 60) do
  pdf.table(@data,
				:at=>[30+o[:x],595+o[:y]],
	      :font_size => 12,
	      :horizontal_padding => 1,
	      :vertical_padding => 1,
	      :border_width => 0,
	      :align => { 0 => :center, 1 => :left, 2 => :center, 3 => :center, 4 => :center },
	      :column_widths => { 0 => 45, 1 => 305, 2 => 55, 3 => 65, 4 => 65})
end
pdf.text number_to_currency(@receipt.total_price), :at=>[510+o[:x],500+o[:y]]	          #suma gravadas
pdf.text "$0.00", :at=>[450+o[:x],500+o[:y]]	                                          #suma exentas
pdf.text number_to_currency(@receipt.total_tax), :at=>[510+o[:x],485+o[:y]]							#iva
pdf.text number_to_currency(@receipt.total_price_with_tax), :at=>[510+o[:x],473+o[:y]]	#total con iva
pdf.text "$?.??", :at=>[510+o[:x],458+o[:y]]																						#retencion
pdf.text "$0.00", :at=>[510+o[:x],445+o[:y]]																						#exentas
pdf.text number_to_currency(@receipt.total_price_with_tax), :at=>[510+o[:x],432+o[:y]]  #total
pdf.text @receipt.total_price_with_tax_in_spanish, :at=>[50+o[:x],500+o[:y]]							#palabras


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
#pdf.text -520, :at=>[o[:x]+0,o[:y]+520]
#pdf.text -540, :at=>[o[:x]+0,o[:y]+540]
#pdf.text -560, :at=>[o[:x]+0,o[:y]+560]
#pdf.text -580, :at=>[o[:x]+0,o[:y]+580]
#pdf.text -600, :at=>[o[:x]+0,o[:y]+600]
#pdf.text -620, :at=>[o[:x]+0,o[:y]+620]
#pdf.text -640, :at=>[o[:x]+0,o[:y]+640]
#pdf.text -660, :at=>[o[:x]+0,o[:y]+660]
#pdf.text -680, :at=>[o[:x]+0,o[:y]+680]
#pdf.text -700, :at=>[o[:x]+0,o[:y]+700]
#pdf.text -720, :at=>[o[:x]+0,o[:y]+720]
#pdf.text -740, :at=>[o[:x]+0,o[:y]+740]
#pdf.text -760, :at=>[o[:x]+0,o[:y]+760]
#pdf.text -780, :at=>[o[:x]+0,o[:y]+780]
#pdf.text -800, :at=>[o[:x]+0,o[:y]+800]


#pdf.text "|", :at =>[0,570]
#pdf.text 1, :at =>[100,570]
#pdf.text 2, :at =>[200,570]
#pdf.text 3, :at =>[300,570]
#pdf.text 4, :at =>[400,570]
#pdf.text 5, :at =>[500,570]

#pdf.text 1, :at =>[-10,560]
#pdf.text 2, :at =>[-20,560]
#pdf.text 3, :at =>[-30,560]
#pdf.text 4, :at =>[-40,560]
#pdf.text 5, :at =>[-50,560]
#pdf.text 6, :at =>[-60,560]
#pdf.text 7, :at =>[-70,560]
#pdf.text 8, :at =>[-80,560]
#pdf.text 9, :at =>[-90,560]
#pdf.text 0, :at =>[-100,560]

#pdf.text 0, :at =>[0,560]
#pdf.text 1, :at =>[10,560]
#pdf.text 2, :at =>[20,560]
#pdf.text 3, :at =>[30,560]
#pdf.text 4, :at =>[40,560]
#pdf.text 5, :at =>[50,560]
#pdf.text 6, :at =>[60,560]
#pdf.text 7, :at =>[70,560]
#pdf.text 8, :at =>[80,560]
#pdf.text 9, :at =>[90,560]
#pdf.text 0, :at =>[100,560]
#pdf.text 1, :at =>[110,560]
#pdf.text 2, :at =>[120,560]
#pdf.text 3, :at =>[130,560]
#pdf.text 4, :at =>[140,560]
#pdf.text 5, :at =>[150,560]
#pdf.text 6, :at =>[160,560]
#pdf.text 7, :at =>[270,560]
#pdf.text 8, :at =>[180,560]
#pdf.text 9, :at =>[190,560]
#pdf.text 0, :at =>[200,560]
#pdf.text 2, :at =>[220,560]
#pdf.text 4, :at =>[240,560]
#pdf.text 6, :at =>[260,560]
#pdf.text 8, :at =>[280,560]
#pdf.text 0, :at =>[300,560]
#pdf.text 2, :at =>[320,560]
#pdf.text 4, :at =>[340,560]
#pdf.text 6, :at =>[360,560]
#pdf.text 8, :at =>[380,560]
#pdf.text 0, :at =>[400,560]
#pdf.text 2, :at =>[420,560]
#pdf.text 4, :at =>[440,560]
#pdf.text 6, :at =>[460,560]
#pdf.text 8, :at =>[480,560]
#pdf.text 0, :at =>[500,560]

