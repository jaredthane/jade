module Formats
  CREDITO_FISCAL_LINES_PER_RECEIPT = 3
  CONSUMIDOR_FINAL_LINES_PER_RECEIPT = 2
  def consumidor_final(receipt)
    @receipt = receipt
		logger.debug "@receipt ->" + @receipt.inspect
		logger.debug "@receipt.lines ->" + @receipt.lines.inspect
    @data=[]
	  total=0
	  for l in receipt.lines
		  x = Object.new.extend(ActionView::Helpers::NumberHelper)
		  if l.product.serialized
			  if l.serialized_product
				  @data << [l.quantity.to_s, l.product.name + " - " + l.serialized_product.serial_number, x.number_to_currency(l.price), "", x.number_to_currency(l.total_price)]
			  end
		  else
			  @data << [l.quantity.to_s, l.product.name, x.number_to_currency(l.price),  x.number_to_currency(l.total_price),""]
		  end
		  total += l.total_price
		end  
		logger.debug "@data ->" + @data.inspect
    prawnto :prawn => { :page_size => 'HALF-LETTER',
					              :left_margin=>0,# was 27
										    :right_margin=>0,
										    :top_margin=>0, #was 90
										    :bottom_margin=>0}
		logger.debug "got here"								    
    pdf_string = render_to_string :template => 'receipts/consumidor_final.pdf.prawn', :layout => false
    File.open(receipt.filename, 'w') { |f| f.write(pdf_string) }
  end
  def credito_fiscal(receipt)
    @receipt = receipt
    @data=[]
	  total=0
	  for l in receipt.lines
		  x = Object.new.extend(ActionView::Helpers::NumberHelper)
		  if l.product.serialized
			  if l.serialized_product
				  @data << [l.quantity.to_s, l.product.name + " - " + l.serialized_product.serial_number, x.number_to_currency(l.price), "", x.number_to_currency(l.total_price)]
			  end
		  else
		  	if (l.received + 2.months >= Date.today)
				  @data << [l.quantity.to_s, l.product.name + " " + (l.received).to_date.to_s(:long) + " - " + (l.received>>1).to_date.to_s(:long), x.number_to_currency(l.price), "", x.number_to_currency(l.total_price)]
				else
				  @data << [l.quantity.to_s, l.product.name + " (" + (l.received).month + ")", x.number_to_currency(l.price), "", x.number_to_currency(l.total_price)]
				end
		  end
		  total += l.total_price
		end  
		logger.debug @data.inspect
    prawnto :prawn => { :page_size => 'LETTER',
					              :left_margin=>0,# was 27
										    :right_margin=>0,
										    :top_margin=>0, #was 90
										    :bottom_margin=>0 }
		logger.debug "got here"								    
    pdf_string = render_to_string :template => 'receipts/credito_fiscal.pdf.prawn', :layout => false
    File.open(receipt.filename, 'w') { |f| f.write(pdf_string) }
  end
end
