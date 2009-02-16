pdf.font.size = 10

pdf.text "Jared Martin", :at=>[45,189]
pdf.text "Calle a Pampe, Parcelacion San Carlos Casa #26", :at=>[45,179]
pdf.text "Santa Ana", :at=>[45,169]
pdf.text "Efectivo", :at=>[81,159]
pdf.text "Chalchuapa", :at=>[171,169]
pdf.text "jmartin", :at=>[194,159]
pdf.text "01/13/09", :at=>[315,189]
pdf.text "Registro", :at=>[315,179]
pdf.text "174634-7474-743-4", :at=>[315,169]
pdf.text "Giro", :at=>[315,159]

pdf.bounding_box([0,135], :width => 409, :height => 67) do
	pdf.table(@data,
					:at=>[0,135],
          :font_size => 10,
          :horizontal_padding => 5,
          :vertical_padding => 1,
          :border_width => 0,
          :widths => { 0 => 31, 1 => 279, 2 => 29, 3 => 25, 4 => 50})
end



