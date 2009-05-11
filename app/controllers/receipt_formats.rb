module Formats
  def consumidor_final
    prawnto :prawn => { :page_size => 'LETTER',#RECEIPT
					              :left_margin=>27,# was 27
										    :right_margin=>5,
										    :top_margin=>90, #was 90
										    :bottom_margin=>18}
    pdf_string = render_to_string :template => 'receipts/consumidor_final.pdf.prawn', :layout => false
    File.open("#{RAILS_ROOT}/invoice_pdfs/order #{@order.id}.pdf", 'w') { |f| f.write(pdf_string) }
  end
  def credito_fiscal
			prawnto :prawn => { :page_size => 'LETTER',
					              :left_margin=>27,# was 27
										    :right_margin=>5,
										    :top_margin=>90, #was 90
										    :bottom_margin=>5, 
										    :page_layout => :landscape }
    pdf_string = render_to_string :template => 'receipts/credito_fiscal.pdf.prawn', :layout => false
    File.open("#{RAILS_ROOT}/invoice_pdfs/order #{@order.id}.pdf", 'w') { |f| f.write(pdf_string) }
  end
end
