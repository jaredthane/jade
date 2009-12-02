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
	belongs_to :order
	belongs_to :warranty
	belongs_to :product	
	validates_presence_of(:product, :message => " debe ser valido")
	attr_accessor :client_name
	attr_accessor :order_type_id
	belongs_to :serialized_product
	attr_accessor :delete_me
  ##################################################################################################
	# Returns quantity if it was marked as received, 0 otherwise
	#################################################################################################
  def real_qty(line)
    qty=0
    if line
      if line.received
        qty=line.quantity
      end
    end
    return qty
  end
	###################################################################################
  # prepares a single movement to be created but DOES NOT SAVE IT
  ##################################################################################
	def new_movement(entity_id, movement_type_id, quantity)
	  value = total_price_with_tax_per_unit*quantity
		m=Movement.new(:created_at=>User.current_user.today,:entity_id => entity_id, :comments => self.order.comments, :product_id => self.product_id, :quantity => quantity, :movement_type_id => movement_type_id, :user_id => User.current_user.id,:order_id => self.id, :serialized_product_id => self.serialized_product_id, :value => value)
	end
  ###################################################################################
  # prepares the movements to be created but DOES NOT SAVE THEM
  ##################################################################################
  before_save :prepare_movements
  MOVEMENT_TYPES=[[4,4],[1,5],[2,6],[8,9],[3,7],[4,4]]
	def prepare_movements
	  if self.product.product_type_id == 1
		  if real_qty(self) != real_qty(old)
		    dir = (real_qty(self)-real_qty(old))/(real_qty(self)-real_qty(old)).abs
			  case (MOVEMENT_TYPES[order_type_id.to_i][dir]+3)/2-1
			    # These are the different movement_types
				  when 1
					  new_movement(self.order.vendor_id, 1, -(real_qty(self)-real_qty(old)))
					  new_movement(self.order.client_id, 1, (real_qty(self)-real_qty(old)))
				  when 2
					  new_movement(self.order.client_id, 2, (real_qty(self)-real_qty(old)))
				  when 3
					  new_movement(self.order.client_id, 3, (real_qty(self)-real_qty(old)))
					  new_movement(self.order.vendor_id, 3, -(real_qty(self)-real_qty(old)))
					# when 4
				  # We won't touch physical counts. The Physical Count model will take care of that.
				  when 5
					  new_movement(self.order.vendor_id, 5, -(real_qty(self)-real_qty(old)))
				  when 6
					  new_movement(self.order.client_id, 6, (real_qty(self)-real_qty(old)))
				  when 7
					  new_movement(self.order.client_id, 7, (real_qty(self)-real_qty(old)))
					  new_movement(self.order.vendor_id, 7, -(real_qty(self)-real_qty(old)))
				  when 8
					  new_movement(self.order.vendor_id, 8, -(real_qty(self)-real_qty(old)))
				  when 9
					  new_movement(self.order.vendor_id, 9, -(real_qty(self)-real_qty(old)))
			  end # case movement_type_id(dir)
		  end # if dir != 0
	  end # if self.product.product_type_id == 1
	end # prepare_movements
	#################################################################################################
	# Holds a copy of the old version of this object for reference
	# By storing it in a accessor, we'll never have to load it more than once
	#################################################################################################
  attr_accessor :old_version
	def old(attribute=nil)
	  if !old_version
	    return nil if !self.id
	    old_version=Line.find_by_id(self.id)
	  end
	  if attribute
      return old_version.attributes[attribute] if old_version
    end
    return old_version
	end
	#################################################################################################
	# Validates the line and adds any errors it finds
	#################################################################################################
	def validate
		if self.product.product_type_id == 1
			if real_qty(self) != real_qty(old)
				case self.order_type_id	# check inventory levels
					when 1 # Venta     
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
				end # case self.order_type_id
			end # if real_qty(self) != real_qty(old)
		end # if self.product.product_type_id == 1
	end # validate
	###################################################################################
	# Returns the revenue account where the value of the order should appear
	# This could be in different accounts depending on the prefrences set up in the prferences table
	# and depending on the values set on the different objects involved
	###################################################################################
	def revenue_account(order=self.order)
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
		return order.vendor.revenue_account
	end
	#################################################################################################
	# Returns the amount of tax per unit
	#################################################################################################
	def tax	
		return self.total_price * self.sales_tax
	end
	###################################################################################
	# Returns the total price of the products on this line
	###################################################################################
	def total_cost
		total = (product.cost ||0) * quantity
		return total
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
	###################################################################################
	# Returns the total price of the products on this line plus tax
	###################################################################################
	def total_price_with_tax_per_unit
		return (price ||0) + (warranty_price || 0) * (1+self.sales_tax)
	end
	###################################################################################
	# Returns Si or No depending on whether the line has been marked as received
	###################################################################################
	def isreceived_str
		if self.isreceived ==1
			return "Si"
		else
			return "No"
		end
	end
	###################################################################################
	# Sets the received date based on a simple yes or no
	###################################################################################
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
	###################################################################################
	# Returns 1 if the line was received, 0 otherwise; for setting checkboxes
	###################################################################################
	def isreceived
		if self.received == nil
			return 0
		else
			return 1
		end
	end
	###################################################################################
	# Sets the received date if true, nil if false
	###################################################################################
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
	###################################################################################
	# Returns the number of months the warranty covers
	###################################################################################
	def warranty_months
		warranty.months if warranty
	end
	###################################################################################
	# Returns true if the product is still under warranty, false otherwise
	###################################################################################
	def under_warranty?
		if self.warranty_expires < Date.today
			return true
		else
			return false
		end
	end
	###################################################################################
	# Returns the date that the warranty expires
	###################################################################################
	def warranty_expires
		if self.warranty and self.received
			return self.received.to_time + self.warranty.months.months
		else
			return nil
		end
	end
	###################################################################################
	# Sets the number of months the product will be under warranty starting from the date received
	###################################################################################
	def warranty_months=(id)
		self.warranty = Warranty.find_by_id(id)
		if self.warranty
			self.warranty_price = self.warranty.price
		end 
	end
	###################################################################################
	# Returns the serial number of a serialized product if there is one
	###################################################################################
	def serial_number
		serialized_product.serial_number if serialized_product
	end
	###################################################################################
	# Sets the serial number of a serialized product if there is one
	# Allows any serial to be entered if this is a purchase or count, 
	# but only an existing serial if this is a sale, transfer, or otherwise
	###################################################################################
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
	###################################################################################
	# Returns the name of the product as a string
	###################################################################################
	def product_name
 	 product.name if product
	end
	###################################################################################
	# Sets the name of the product as a string
	###################################################################################
	def product_name=(name)
		self.product = Product.find_by_name(name) unless name.blank?
	end
	###################################################################################
	# Returns the name of the bar code as a string
	###################################################################################
	def bar_code
 	 product.upc if product
	end
	###################################################################################
	# sets the product and price by searching for a product by the given string
	# At the time of this writing, you can search by:
	# name, upc, model, and description
	###################################################################################
	def bar_code=(upc)
		if !upc.blank?		
			prod= Product.find_single(upc)
			if prod != nil
				self.product_id = prod.id
			end
		end
		if self.order
			if self.order.order_type_id == 1
				self.price = self.product.price if self.product
			else
				self.price = self.product.cost if self.product
			end
		else
			if self.order_type_id.to_i == 1
				self.price = self.product.price(User.current_user.current_price_group,1) if self.product
			else
				self.price = self.product.cost if self.product
			end
		end
	end
end
