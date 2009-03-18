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
  before_save :prepare_movements
  after_create :create_movements
  after_update :create_movements
  belongs_to :receipt
  before_create :set_taxes
  before_update :set_taxes
	belongs_to :order
	belongs_to :warranty
	belongs_to :product	
	validates_presence_of(:product, :message => " debe ser valido")
	attr_accessor :movements_to_create
	attr_accessor :client_name
	attr_accessor :order_type_id
	belongs_to :serialized_product
	def set_taxes
		self.tax = self.total_price * 0.15
	end
	def validate
		logger.debug  "validating line"
		if self.product.product_type_id == 1
			##logger.debug  "@movements_to_create.length=" + @movements_to_create.length.to_s
			if @movements_to_create # if we find stuff here, there is movement
				logger.debug  " there are movements to validate"
#				logger.debug  "self.last_change_type =" + self.last_change_type.to_s
				case self.order_type_id	# check inventory levels
					when 1 # Venta     
						#logger.debug  "validating Venta"
						qty=order.vendor.inventory(self.product)
						errors.add " ","Solo hay " + qty.to_s + " " + self.product.unit.name + " del producto " + self.product.name + " en el inventario"  if self.quantity > qty
						logger.debug  "self.serialized_product=" + self.serialized_product.to_s if self.serialized_product
						if self.product.serialized
							if self.serialized_product
									#logger.debug  "self.serialized_product.location.id=" + self.serialized_product.location.id.to_s
									logger.debug  "@order.vendor.id=" + @order.vendor.id.to_s
									errors.add "El numero de serie " + self.serialized_product.serial_number + " no esta disponible en este sitio" if self.serialized_product.location != @order.vendor
							else
								errors.add "El numero de serie " + self.serialized_product.serial_number + " no se encuentra en el registro"
							end
						end
						# Serial number should exist, and be in vendors location
					when 2 # Compra
						#logger.debug  "validating Compra"
						# Serial number may or may not exist
						# if it does its location should be nil
						# if not, it should be unqiue to the product, add it
					when 3 # Transferencia
						#logger.debug  "validating Transferencia"
						logger.debug  "order.vendor.inventory(self.product)=" + order.vendor.inventory(self.product).to_s
						errors.add "no hay suficiente inventario del producto señalado" if self.quantity > order.vendor.inventory(self.product)	
						errors.add "numero de serie no esta disponible en sitio señalado" if !self.serialized_product 
						# Serial number should exist, and be in vendors location
					when 5 # Devolucion de Venta
						##logger.debug  "validating Devolucion de Venta"
						##logger.debug  "self.product.id=" + self.product.id.to_s
						#errors.add "insufficient stock" if self.quantity > order.client.inventory(self.product)
						# Serial number should exist
						# its location should be nil
						# dont need to validate serial cause it was already validated
					when 6 # Devolucion de Compra
						#logger.debug  "validating Devolucion de Compra"
						errors.add "no hay suficiente inventario del producto señalado" if self.quantity > order.client.inventory(self.product)	
						# Serial number should exist, and be in clients location
						# dont need to validate serial cause it was already validated
					when 7 # Devolucion de Transferencia	
						#logger.debug  "validating Devolucion de Transferencia"				
						errors.add "no hay suficiente inventario del producto señalado" if self.quantity > order.client.location.inventory(self.product)
						# Serial number should exist, and be in clients location
						# dont need to validate serial cause it was already validated
				end
			end		
		end
	end
	def create_movements
		@movements_to_create = [] if !@movements_to_create
		for m in @movements_to_create
			# Save movement from the list
			m.line_id=self.id
			m.save
			qty=m.quantity || 0

			p=Product.find(self.product_id)
			if p.product_type_id==1
				i=p.inventories.find_by_entity_id(m.entity_id)
				i.quantity=i.quantity + m.quantity
				i.save
			end
			# Update inventory levels
#			logger.info "about to calc the cost"
			
			p.cost=p.calculate_cost
#			logger.info "the calculated cost is #{p.calculate_cost}"
#			logger.info "the cost is #{p.cost}"
#			logger.info "the cost was saved as #{Product.find(self.product_id).cost}"
		end
		# Erase list
		@movements_to_create.clear
	end
	def create_movement_for(entity_id, movement_type_id, quantity)
		m=Movement.new(:entity_id => entity_id, :comments => self.order.comments, :product_id => self.product_id, :quantity => quantity, :movement_type_id => movement_type_id, :user_id => User.current_user.id,:order_id => self.order.id, :serialized_product_id => self.serialized_product_id, :line_id => self.id)
		@movements_to_create = [] if !@movements_to_create 
		@movements_to_create.push(m)
	end
	def total_price
		total = ((price ||0) + (warranty_price || 0)) * quantity
		return total
	end
	def total_price_with_tax
		total = total_price + tax
		return total
	end
	def quantity_change_direction(new, old)
		if new.received and !old.received 		# The line was marked received
			return 1
		elsif old.received and !new.received	# The line was unmarked received
			return -1 
		elsif old.received and new.received		# The line was always received
			if new.quantity > old.quantity			# The quantity increased
				return 1
			elsif new.quantity < old.quantity		# The quantity decreased
				return -1
			end
		end
		return 0
	end
	def quantity_change(new, old)
		if old
			if new.received == old.received
				return new.quantity - old.quantity
			else
				if new.received
					return new.quantity
				else
					return -new.quantity		
				end		
			end
		else
			return new.quantity
		end
	end
	def movement_type_id(direction)
		case order.order_type_id
			when 1
				if direction==1
					return 1
				else
					return 5
				end
			when 3
				if direction==1
					return 8
				else
					return 9
				end
			when 2
				if direction==1
					return 2
				else
					return 6
				end
			when 4
				if direction==1
					return 3
				else
					return 7			
				end
			when 5
				return 4
			else
				return 4
		end		
	end
	def prepare_movements
		if self.product.product_type_id == 1
			old = Line.find_by_id(self.id)
			puts old.inspect
			if old
				dir = quantity_change_direction(self, old)
			else
				dir = 1
			end
#			puts "----------------->" + dir.to_s
			if dir != 0
				case self.movement_type_id(dir)
					when 1
						create_movement_for(order.vendor_id, 1, -quantity_change(self, old))
					when 2
						create_movement_for(order.client_id, 2, quantity_change(self, old))
					when 3
						create_movement_for(order.client_id, 3, quantity_change(self, old))
						create_movement_for(order.vendor_id, 3, -quantity_change(self, old))
					# We won't touch physical counts. The Physical Count model will take care of that.
					when 5
						create_movement_for(order.vendor_id, 5, -quantity_change(self, old))
					when 6
						create_movement_for(order.client_id, 6, quantity_change(self, old))
					when 7
						create_movement_for(order.client_id, 7, quantity_change(self, old))
						create_movement_for(order.vendor_id, 7, -quantity_change(self, old))
					when 8
						create_movement_for(order.vendor_id, 8, -quantity_change(self, old))
					when 9
						create_movement_for(order.vendor_id, 9, -quantity_change(self, old))
				end
			end
		end
	end
	def isreceived_str
		if self.isreceived ==1
			return "Si"
		else
			return "No"
		end
	end
	def isreceived_str=(str)
		logger.debug "str=#{str.to_s}"
		if str=="" or str=="no" or str=="No" or str=="NO"
			logger.debug "setting to no"
			self.isreceived = 0
		else
			self.isreceived = 1
			logger.debug "setting to yes"
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
		logger.debug "serial=" + serial.to_s
		if (!(serial == "" or serial == "\n") and (order.order_type_id==2))
			logger.debug "Taking create path"
			s=SerializedProduct.find_or_create_by_serial_number(serial)
			if s.product_id==nil
				logger.debug "self.product_id=#{self.product_id.to_s}"
				s.product_id=(self.product_id )
				s.save
			end
		else
			logger.debug  "taking find path"
			s=SerializedProduct.find_by_serial_number(serial)
		end
		if self.serialized_product # the line was already marked as delivered
			logger.debug  "the line was already marked as delivered"
			if !(serial == "" or serial == "\n")
				if s != self.serialized_product # only need to work if it's been changed
					logger.debug  "we are changing the serial numbers delivered for the line"
					# we are changing the serial numbers delivered for the line
					# because it is an existing order, we can create the movements now.
					
					# This is a Compra(2), Venta(1), o Transaccion(3)
					
					self.isreceived=0
					self.serialized_product = s
					self.isreceived=1
				end
			else # we are marking the line as not delivered after it was previously delivered
				logger.debug  "we are marking the line as not delivered after it was previously delivered"
				
				# This is a Devolucion of Compra(6), Venta(5), o Transaccion(7)
				logger.debug  "setting isreceived=0"
				self.isreceived=0
				self.serialized_product = nil # s was also nil
			end
		else # the line was previously undelivered
			logger.debug  "the line was previously undelivered"
			if !(serial == "" or serial == "\n")
				logger.debug  "delivering previously undelivered serial"
				# either this is a new order, or is simply undelivered until now.
				
				# This is a Compra(2), Venta(1), o Transaccion(3)
				
				self.serialized_product = s
				self.isreceived=1
			end
		end
	end
	def product_name
 	 product.name if product
	end
	def product_name=(name)
		puts "Setting product name..................."
		puts "name=" + name.to_s
		self.product = Product.find_by_name(name) unless name.blank?
		
	end
	def bar_code
 	 product.upc if product
	end
	def bar_code=(upc)
		logger.info "upc=#{upc.to_s}"	
		logger.info "have self.product_id=#{self.product_id.to_s}"
		if !upc.blank?		
			prod = Product.find_by_upc(upc)
			logger.debug "prod=#{prod.to_s}"
			if prod != nil
				logger.debug "getting id of prod"
				logger.debug "prod.id=#{prod.id.to_s}"
				self.product_id = prod.id
			end
			logger.info "Product.find_by_upc(upc)=#{Product.find_by_upc(upc).inspect}"
#			logger.info "Product.find_by_upc(upc).id=#{Product.find_by_upc(upc).id.to_s}"
		end
		logger.info "found self.product_id=#{self.product_id.to_s}"
		if self.order
			puts "we have an order"
			if self.order.order_type_id = 1
				puts self.order.order_type_id
				self.price = self.product.price if self.product
			else
				puts self.order.order_type_id
				self.price = self.product.cost if self.product
			end
		else
			puts "we dont have an order"
			puts "before again "+self.order_type_id.to_s
			if self.order_type_id == 1
				puts self.order_type_id
				self.price = self.product.price(User.current_user.current_price_group,1) if self.product
			else
				puts self.order_type_id
				self.price = self.product.cost if self.product
			end
		end
	end
end
