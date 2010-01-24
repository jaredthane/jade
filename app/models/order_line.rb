class OrderLine < BaseLine
	belongs_to :order, :foreign_key => 'parent_id'
	##############################################################
	# Getter and Setter for price
	##############################################################
	def price=(val)
		value2=val
	end # def price=(val)
	def price
		return value2
	end # def price
	##############################################################
	# Getter and Setter for tax rate
	# This is the percentage of tax applied to the line.
	# This is done at the line level since you might have some exempt products on the order
	##############################################################
	def tax_rate(val)
		value1=val
	end # def 	tax_rate(val)
	def tax_rate
		return value1
	end # def tax_rate
		
end
