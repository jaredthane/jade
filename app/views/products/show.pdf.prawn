pdf.font "Helvetica" 
pdf.font.size = 13
pdf.text "Product: #{@product.name}", :size => 16, :style => :bold, :spacing => 4
pdf.text "Vendor: #{@product.vendor.name}", :spacing => 16
pdf.text @product.description
