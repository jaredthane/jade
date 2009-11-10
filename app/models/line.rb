# Jade Inventory Control System
#Copyright (C) 2009  Jared T. Martin

#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.

#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.

#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.


class Line < ActiveRecord::Base
	
	HUMANIZED_ATTRIBUTES = {
    :order => "Pedido",
    :product => "Producto"
  }

  def self.human_attribute_name(attr)
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
  belongs_to :receipt
#  before_create :set_taxes
#  before_update :set_taxes
	belongs_to :order
	belongs_to :warranty
	belongs_to :product	
	validates_presence_of(:product, :message => " debe ser valido")
	attr_accessor :movements_to_create
	attr_accessor :client_name
	attr_accessor :order_type_id
	belongs_to :serialized_product

#	def set_taxes
#		self.sales_tax = 0.13
#	end
	def tax	
		return self.total_price * self.sales_tax
	end
	def validate
		#puts  "validating line"
		if self.product.product_type_id == 1
			###puts  "@movements_to_create.length=" + @movements_to_create.length.to_s
			if @movements_to_create # if we find stuff here, there is movement
				#puts  " there are movements to validate"
#				#puts  "self.last_change_type =" + self.last_change_type.to_s
				case self.order_type_id	# check inventory levels
					when 1 # Venta     
						##puts  "validating Venta"
						qty=order.vendor.inventory(self.product)
						errors.add " ","Solo hay " + qty.to_s + " " + self.product.unit.name + " del producto " + self.product.name + " en el inventario"  if self.quantity > qty
						#puts  "self.serialized_product=" + self.serialized_product.to_s if self.serialized_product
						if self.product.serialized
							if self.serialized_product
									##puts  "self.serialized_product.location.id=" + self.serialized_product.location.id.to_s
									#puts  "@order.vendor.id=" + @order.vendor.id.to_s
									errors.add "El numero de serie " + self.serialized_product.serial_number + " no esta disponible en este sitio" if self.serialized_product.location != @order.vendor
							else
								errors.add "El numero de serie " + self.serialized_product.serial_number + " no se encuentra en el registro"
							end
						end
						# Serial number should exist, and be in vendors location
					when 2 # Compra
						##puts  "validating Compra"
						# Serial number may or may not exist
						# if it does its location should be nil
						# if not, it should be unqiue to the product, add it
					when 3 # Transferencia
						##puts  "validating Transferencia"
						#puts  "order.vendor.inventory(self.product)=" + order.vendor.inventory(self.product).to_s
						errors.add "no hay suficiente inventario del producto señalado" if self.quantity > order.vendor.inventory(self.product)	
						errors.add "numero de serie no esta disponible en sitio señalado" if !self.serialized_product 
						# Serial number should exist, and be in vendors location
					when 5 # Devolucion de Venta
						###puts  "validating Devolucion de Venta"
						###puts  "self.product.id=" + self.product.id.to_s
						#errors.add "insufficient stock" if self.quantity > order.client.inventory(self.product)
						# Serial number should exist
						# its location should be nil
						# dont need to validate serial cause it was already validated
					when 6 # Devolucion de Compra
						##puts  "validating Devolucion de Compra"
						errors.add "no hay suficiente inventario del producto señalado" if self.quantity > order.client.inventory(self.product)	
						# Serial number should exist, and be in clients location
						# dont need to validate serial cause it was already validated
					when 7 # Devolucion de Transferencia	
						##puts  "validating Devolucion de Transferencia"				
						errors.add "no hay suficiente inventario del producto señalado" if self.quantity > order.client.location.inventory(self.product)
						# Serial number should exist, and be in clients location
						# dont need to validate serial cause it was already validated
				end
			end		
		end
	end
	###################################################################################
	# Returns the total price of the products on this line
	###################################################################################
	def total_cost
		total = (product.cost ||0) * quantity
		return total
	end
	def revenue_account(order=self.order)
		puts "REady to try accounts"
		for pref in Preference.find(:all, :order=>'value', :conditions=>"pref_group='revenue'")
			puts "Trying " + pref.name
			case pref.id
			when 1 #Product
				#puts " Grabbing revenue account from Product"
				return product.revenue_account if product.revenue_account
			when 2 #Category
				#puts " Grabbing revenue account from Category"
				if product.product_category
					return product.product_category.revenue_account if product.product_category.revenue_account
				end
			when 3 #Vendor
				#puts " Grabbing revenue account from Vendor"
				if product.vendor
					return product.vendor.revenue_account if product.vendor.revenue_account
				end
			when 4 #Site
				#puts " Grabbing revenue account from Site"
				if order.vendor
					return order.vendor.revenue_account if order.vendor.revenue_account
				end
			when 5 #Clients Rep
				#puts " Grabbing revenue account from Clients Rep"
				if order.client
					if order.client.user
						return order.client.user.revenue_account if order.client.user.revenue_account
					end
				end
			when 6 #Current User
				#puts " Grabbing revenue account from Current User"
				return User.current_user.revenue_account if User.current_user.revenue_account
			end
		end
		# If there are no other valid options, use the sites revenue account
		
		puts "we gave up"
		return order.vendor.revenue_account
	end
  ###################################################################################
	# Returns the total price of the products on this line
	###################################################################################
	def total_price
		total = ((price ||0) + (warranty_price || 0)) * (quantity || 0)
		return total
	end
	###################################################################################
	# Returns the total price of the products on this line plus tax
	###################################################################################
	def total_price_with_tax
		total = (self.total_price||0) + (self.tax||0)
		return total
	end
	def isreceived_str
		if self.isreceived ==1
			return "Si"
		else
			return "No"
		end
	end
	def isreceived_str=(str)
		#puts "str=#{str.to_s}"
		if str=="" or str=="no" or str=="No" or str=="NO"
			#puts "setting to no"
			self.isreceived = 0
		else
			self.isreceived = 1
			#puts "setting to yes"
		end
	end
	def isreceived
		if self.received == nil
			return 0
		else
			return 1
		end
	end
	def isreceived=(checkbox)
		if checkbox.to_i==1
			if self.received == nil
				self.received=Time.now
			end
		else
			if self.received != nil
				self.received=nil
			end
		end
	end
	def warranty_months
		warranty.months if warranty
	end
	def under_warranty?
		if self.warranty_expires < Date.today
			return true
		else
			return false
		end
	end
	def warranty_expires
		if self.warranty and self.received
			return self.received.to_time + self.warranty.months.months
		else
			return nil
		end
	end
	def warranty_months=(id)
		self.warranty = Warranty.find(id)
		if self.warranty
			self.warranty_price = self.warranty.price
		end 
	end
	def serial_number
		serialized_product.serial_number if serialized_product
	end
	def serial_number=(serial)
		puts "##################################################################################################"
		puts "# "
		puts "#################################################################################################"
		puts "serial=" + serial.to_s
#		puts "self.order_type_id=#{order.order_type_id.to_s}"
	puts self.order_type_id
		if (!(serial == "" or serial == "\n") and ((self.order_type_id==2) or (self.order_type_id==5)))
			puts "Taking create path"
			s=SerializedProduct.find_or_create_by_serial_number(serial)
			if s.product_id==nil
				puts "self.product_id=#{self.product_id.to_s}"
				s.product_id=(self.product_id )
				s.save
			end   
		else
			puts  "taking find path"
			s=SerializedProduct.find_by_serial_number(serial)
		end
		if self.order_type_id == 5
			self.serialized_product=s
			puts "Skipping creating movements cause this is a count"
		else
			if self.serialized_product # the line was already marked as delivered
				puts  "the line was already marked as delivered"
				if !(serial == "" or serial == "\n")
					if s != self.serialized_product # only need to work if it's been changed
						puts  "we are changing the serial numbers delivered for the line"
						# we are changing the serial numbers delivered for the line
						# because it is an existing order, we can create the movements now.
				
						# This is a Compra(2), Venta(1), o Transaccion(3)
				
						self.isreceived=0
						self.serialized_product = s
						self.isreceived=1
					end
				else # we are marking the line as not delivered after it was previously delivered
					puts  "we are marking the line as not delivered after it was previously delivered"
			
					# This is a Devolucion of Compra(6), Venta(5), o Transaccion(7)
					puts  "setting isreceived=0"
					self.isreceived=0
					self.serialized_product = nil # s was also nil
				end
			else # the line was previously undelivered
				#puts  "the line was previously undelivered"
				if !(serial == "" or serial == "\n")
					puts  "delivering previously undelivered serial"
					# either this is a new order, or is simply undelivered until now.
		
					# This is a Compra(2), Venta(1), o Transaccion(3)
		
					self.serialized_product = s
					self.isreceived=1
				end #we have a number
			end #already had a serial?
		end #ordertype=5
	end #end def
	def product_name
 	 product.name if product
	end
	def product_name=(name)
		#puts "Setting product name..................."
		#puts "name=" + name.to_s
		self.product = Product.find_by_name(name) unless name.blank?
		
	end
	def bar_code
 	 product.upc if product
	end
	def bar_code=(upc)
		#logger.info "upc=#{upc.to_s}"	
		#logger.info "have self.product_id=#{self.product_id.to_s}"
		if !upc.blank?		
			prod = Product.find_by_upc(upc)
			#puts "prod=#{prod.to_s}"
			if prod != nil
				#puts "getting id of prod"
				#puts "prod.id=#{prod.id.to_s}"
				self.product_id = prod.id
			end
			#logger.info "Product.find_by_upc(upc)=#{Product.find_by_upc(upc).inspect}"
#			#logger.info "Product.find_by_upc(upc).id=#{Product.find_by_upc(upc).id.to_s}"
		end
		#logger.info "found self.product_id=#{self.product_id.to_s}"
		if self.order
			#puts "we have an order"
			if self.order.order_type_id == 1
				#puts "self.order.order_type_id" + self.order.order_type_id.to_s
				self.price = self.product.price if self.product
			else
				#puts "self.order.order_type_id" + self.order.order_type_id.to_s
				self.price = self.product.cost if self.product
			end
		else
			#puts "we dont have an order"
			#puts "before again "+self.order_type_id.to_s
			if self.order_type_id.to_i == 1
				#puts "self.order_type_id" + self.order_type_id.to_s
				#puts "its a sale"
				self.price = self.product.price(User.current_user.current_price_group,1) if self.product
			else
				#puts "self.order_type_id" + self.order_type_id.to_s
				#puts "its not a sale"
				self.price = self.product.cost if self.product
			end
		end
	end
end
