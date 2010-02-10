class CountLine < BaseLine
	belongs_to :count, :foreign_key => 'parent_id'
	
  ###################################################################################
	# Returns the total price of the products on this line
	# Overloads BaseLine
	###################################################################################
	def total_price
		return 0 if !self.quantity
		return self.product.cost * ((self.quantity || 0) - (self.previous_qty || 0))
	end
	##############################################################
	# Getter and Setter for value
	##############################################################
	def value=(val)
		value2=val
	end # def price=(val)
	def value
		return value2
	end # def price
end
