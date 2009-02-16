class Line < ActiveRecord::Base
	
	HUMANIZED_ATTRIBUTES = {
    :order => "Pedido",
    :product => "Producto"
  }

  def self.human_attribute_name(attr)
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
  after_create :create_movements_on_save
  after_update :create_movements_on_save
  belongs_to :receipt
  before_create :set_taxes
  before_update :set_taxes
	belongs_to :order
	belongs_to :warranty
	belongs_to :product	
	validates_presence_of(:product, :message => " debe ser valido")
	attr_accessor :movements_to_create
	attr_accessor :client_name
	belongs_to :serialized_product
	def check_create_movements
	#	#logger.debug  self.order.client_id
	#	#logger.debug  "im here"
	#	create_movement(self.movements_to_make-2) if self.movements_to_make
	#	self.movements_to_make=nil
		# need to save this value here
	end
	def set_taxes
		self.tax = self.total_price * 0.15
	end
	def validate
		logger.debug  "validating line"
		if self.product.product_type_id != 4
			##logger.debug  "@movements_to_create.length=" + @movements_to_create.length.to_s
			if @movements_to_create # if we find stuff here, there is movement
				logger.debug  " there are movements to validate"
				logger.debug  "self.last_change_type =" + self.last_change_type.to_s
				case self.last_change_type	# check inventory levels
					when 1 # Venta     
						#logger.debug  "validating Venta"
						errors.add "no hay suficiente inventario del producto señalado" if self.quantity > order.vendor.inventory(self.product)
						logger.debug  "self.serialized_product=" + self.serialized_product.to_s if self.serialized_product
						if self.product.serialized
							if self.serialized_product
									#logger.debug  "self.serialized_product.location.id=" + self.serialized_product.location.id.to_s
									logger.debug  "@order.vendor.id=" + @order.vendor.id.to_s
									errors.add "Este numero de serie no esta disponible en este sitio" if self.serialized_product.location != @order.vendor
							else
								errors.add "Este numero de serie no se encuentra en el registro"
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
	def create_movements_on_save
		
		#self.product.cost=self.product.calculate_cost## <-------------- Remove this line for production!!!
		self.product.save
		@movements_to_create = [] if !@movements_to_create
		#logger.debug  "movements_to_create has " + @movements_to_create.length.to_s
		for m in @movements_to_create
			#logger.debug  "adding movement to queue" + m.entity_id.to_s + "-" + m.movement_type_id.to_s + "-" + m.quantity.to_s
			# Save movement from the list
			m.line_id=self.id
			m.save
			# Update inventory levels
			p=Product.find(self.product_id)
			p.cost=p.calculate_cost
			p.save
			i=p.inventories.find_by_entity_id(m.entity_id)
			#logger.debug  "old qty was" + i.quantity.to_s
			qty=m.quantity || 0
			i.quantity=i.quantity + m.quantity
			i.save
			#logger.debug  "new qty is " + i.quantity.to_s
			
		end
		# Erase list
		@movements_to_create.clear
	end
	def create_movement_for(entity_id, movement_type_id, quantity)
		#logger.debug  "adding movement to queue" + entity_id.to_s + "-" + movement_type_id.to_s + "-" + quantity.to_s
		logger.debug  "self.product_id=" + self.product_id.to_s
		logger.debug  "quantity=" + quantity.to_s
		logger.debug  "movement_type_id=" + movement_type_id.to_s
		logger.debug  "self.order.comments=" + self.order.comments.to_s
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
	def last_change_type
		#logger.debug  "self.received=" + self.received.to_s
		#logger.debug  "self.isreceived=" + self.isreceived.to_s
		if isreceived==1
			direction=1
		else
			direction=-1
		end
		#logger.debug  "direction=" + direction.to_s + " order.order_type=" + order.order_type.to_s
		case order.order_type
			when 'sales'
				if direction==1
					return 1
				else
					return 5
				end
			when 'purchases'
				if direction==1
					return 2
				else
					return 6
				end
			when 'transfers'
				if direction==1
					return 3
				else
					return 7			
				end
			else
				return 4
		end		
	end
	def create_movement
		logger.debug  "self.received=" + self.received.to_s
		case self.last_change_type
			when 1
				create_movement_for(order.vendor_id, 1, -self.quantity)
			when 2
				create_movement_for(order.client_id, 2, self.quantity)
			when 3
				create_movement_for(order.client_id, 3, self.quantity)
				create_movement_for(order.vendor_id, 3, -self.quantity)
			when 4
				create_movement_for(order.vendor_id, 4, self.quantity)
			when 5
				create_movement_for(order.vendor_id, 5, self.quantity)
			when 6
				create_movement_for(order.client_id, 6, -self.quantity)
			when 7
				create_movement_for(order.client_id, 7, -self.quantity)
				create_movement_for(order.vendor_id, 7, self.quantity)	
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
		logger.debug 'Checkbox='+checkbox.to_i.to_s
		if checkbox.to_i==1
			logger.debug 'saving date'
			logger.debug  "order id is " + order.id.to_s
			
			if self.received == nil
				self.received=Time.now
				create_movement
			end
		else
			if self.received != nil
				logger.debug 'removing date'
				self.received=nil
				logger.debug  "self.received=" + self.received.to_s
				create_movement
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
		logger.debug "order.order_type=" + order.order_type.to_s
		logger.debug "serial=" + serial.to_s
		if (!(serial == "" or serial == "\n") and (order.order_type=='purchases'))
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
			logger.info "Product.find_by_upc(upc).id=#{Product.find_by_upc(upc).id.to_s}"
		end
		logger.info "found self.product_id=#{self.product_id.to_s}"
		self.price = self.product.price if self.product
	end
end
