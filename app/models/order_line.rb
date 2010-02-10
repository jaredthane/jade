class OrderLine < BaseLine
	belongs_to :order, :foreign_key => 'parent_id'
	
  ###################################################################################
	# Returns the total price of the products on this line
	###################################################################################
	def total_price
		return ((price ||0) + (warranty_price || 0) * (quantity || 0)
	end
	
	###################################################################################
	# Returns the total price of the products on this line plus tax
	###################################################################################
	def total_price_with_tax
		total = (self.total_price||0) + (self.tax||0)
		return total
	end
	###################################################################################
	# Returns the total price of the products on this line plus tax
	###################################################################################
	def price_with_tax
		return (price ||0) + (warranty_price || 0) * (1+TAX)
	end
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
	
	#################################################################################################
	# Returns the amount of tax per unit
	#################################################################################################
	def tax_per_unit
		return 0 if !self.order
		return 0 if !self.order.client
				if self.order.client.type == ''
					return self.total_price * TAX
				end
		return 0
	end
end
