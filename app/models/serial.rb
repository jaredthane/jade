class Serial < ActiveRecord::Base
	belongs_to :product
	
	
	##################################################################################################
	# Stores
	#################################################################################################
	attr_accessor :_number
	def number=(str)
		self._number=str
	end # def number=(str)
	def number
		return self._number if self._number
		_number = self.id.split('~')[0]
	end # def number
	
	##############################################################
	# Creates a virtual product attribute
	##############################################################
	attr_accessor :_product_id
	attr_accessor :_product
	def load_product
		if self.id
			_product_id = self.id.split('~')[1]
			_product = BaseProduct.find(_product_id)
		end
	end
	def product=(obj)
		self._product=obj
		self._product_id=obj.id
	end # def product=(obj)
	def product_id=(val)
		self._product=BaseProduct.find(val)
		self._product_id=val
	end # def method_name
	def product
		return _product if _product
		load_product if self.id
		return _product
	end # def product
	def product_id
		return _product_id if _product_id
		load_product if self.id
		return _product_id
	end # def product_id
	##############################################################
	# Sets the id=   "{number}~{product_id}"
	##############################################################
	before_create :set_id
	def set_id
		self.id=self.number + "~" + self.product_id
		logger.debug self.number + "~" + self.product_id
		
#		logger.debug "Here!"
	end # def set_id
	
end
