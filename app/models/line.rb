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
    liquid_methods :product, :quantity, :price, :total_price
	belongs_to :order
	belongs_to :warranty
	belongs_to :product	
	belongs_to :movement
	validates_presence_of(:product, :message => " debe ser valido")
	attr_accessor :client_name
	belongs_to :serialized_product
	has_many :movements, :dependent => :destroy
	attr_accessor :delete_me
	before_save :pre_save
	def pre_save
		prepare_movements
	end
	before_save :post_save
	def post_save
		save_movements
	end
    def to_liquid
        { "product"  => self.product,
          "lines" => self.lines }
    end

	##################################################################################################
	# accepts a date in string format
	# returns same in dateTime format
	# This is duplicated here and in the app controller
	#################################################################################################
	def untranslate_month(date)
	    # logger.debug "HELOOOOOO"
        if date
	        # logger.debug "its not null"
	        # logger.debug "date is a " + date.class.to_s
            if date.class==String
	            # logger.debug "its a string"
                if date.include? "-"
	                # logger.debug "first method"
                    return DateTime.strptime(date, '%Y-%m-%d %H:%M:%S')
                elsif date.include? ":"
                    # logger.debug "trying second method"
                    return DateTime.strptime(date, '%d/%m/%Y %H:%M:%S')

                else
                    # logger.debug "stuck"
                    if date!=''
	                    # logger.debug "third method"
                        return Date.strptime(date, '%d/%m/%Y')
                    else 
                        
	                # logger.debug "gave up"
                        return nil
                    end
                end
            elsif date.class==Date or date.class==DateTime
                # logger.debug "its already a date"
                return date
            end
        else
            # logger.debug "returning null"
            return nil	
        end
	end
	def attrs=(hash)
		self.order_type_id = hash[:order_type_id] if hash[:order_type_id]
		self.quantity = hash[:quantity] if hash[:quantity]
		self.format_unit_price = hash[:format_unit_price] if hash[:format_unit_price]
		self.format_price = hash[:format_price] if hash[:format_price]
		self.warranty_months = hash[:warranty_months] if hash[:warranty_months]
		self.cost = hash[:cost] if hash[:cost]
		self.product_id = hash[:product_id] if hash[:product_id]
		self.serial_number = hash[:serial_number] if hash[:serial_number]
		# logger.debug "Before:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::" + hash[:received].to_s
		self.received = untranslate_month(hash[:received]) if hash[:received]
		# logger.debug "After:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::" + self.received.to_s
	end
    #################################################################################################
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
    ##################################################################################
    # prepares a single movement to be created but DOES NOT SAVE IT
    ##################################################################################
    def new_movement(entity_id, movement_type_id, quantity)
        value = total_price_with_tax_per_unit*quantity
        if self.serialized_product_id
            serial=self.serialized_product_id
        else
            serial = old.serialized_product_id
        end
        m=Movement.new(:created_at=>User.current_user.today,:entity_id => entity_id, :comments => self.order.comments, :product_id => self.product_id, :quantity => quantity, :movement_type_id => movement_type_id, :user_id => User.current_user.id,:order_id => self.order.id, :serialized_product_id => serial, :line_id => self.id)
        return m
    end
  ##################################################################################
  # prepares the movements to be created but DOES NOT SAVE THEM
  ##################################################################################
  MOVEMENT_TYPES=[[4,4],[5,1],[6,2],[9,8],[7,3],[4,4]]
  def prepare_movements
    return 0 if self.product.product_type_id != 1
    new_qty=(real_qty(self)||0)
    old_qty=(real_qty(old)||0)
#    logger.debug("new_qty"+new_qty.to_s)
#    logger.debug("old_qty"+old_qty.to_s)
#    logger.debug("=="+(new_qty==old_qty).to_s)
    return 0 if new_qty == old_qty
    
    dir = (new_qty-old_qty)/((new_qty||0)-(old_qty||0)).abs
    move=MOVEMENT_TYPES[order_type_id.to_i][(dir+3)/2-1]
    qty=(new_qty-old_qty)

    if [Movement::SALE, Movement::PURCHASE, Movement::TRANSFER, Movement::INTERNAL_CONSUMPTION].include?(move)    	# These are normal movements
        if move == Movement::PURCHASE
            cost=self.price
        else
            cost = Movement.consume(self.product, qty, self.order.vendor)
        end
        self.cost=cost
    	self.movements << Movement.new(
            :created_at=>User.current_user.today,
            :entity_id => self.order.vendor_id, 
            :comments => self.order.comments, 
            :product_id => self.product_id, 
            :quantity => -qty, 
            :movement_type_id => move, 
            :user_id => User.current_user.id,
            :order_id => self.id, 
            :serialized_product_id => self.serialized_product_id, 
            :cost => cost, 
            :price => self.price, 
            :cost_left => nil,
            :quantity_left => nil,
            :line_id => self.id
  	  )
  		self.movements << Movement.new(
            :created_at=>User.current_user.today,
            :entity_id => self.order.client_id, 
            :comments => self.order.comments, 
            :product_id => self.product_id, 
            :quantity =>  qty,
            :movement_type_id => move, 
            :user_id => User.current_user.id,
            :order_id => self.id, 
            :serialized_product_id => self.serialized_product_id,
            :cost => cost, 
            :price => self.price,
            :cost_left => cost,
            :quantity_left => qty,
            :line_id => self.id
  	  ) if move != 8 # Dont worry about the client for an internal consuption
	elsif [5,6,7,9].include?(move) 	# These are returns, use old serial_number
        if move == Movement::PURCHASE_RETURN
            cost = Movement.consume(self.product, qty, self.order.vendor, :first=>false)
        else
            cost = self.cost
        end
	    cost = Movement.consume(self.product, qty, self.order.client)
        self.cost=cost
  		self.movements << Movement.new(
            :created_at=>User.current_user.today,
            :entity_id => self.order.client_id, 
            :comments => self.order.comments, 
            :product_id => self.product_id, 
            :quantity =>  qty, 
            :movement_type_id => move, 
            :user_id => User.current_user.id,
            :order_id => self.id, 
            :serialized_product_id => old.serialized_product_id,
            :cost => cost, 
            :price => self.price,
            :cost_left => nil,
            :quantity_left => nil,
            :line_id => self.id
  	  ) if move != 9 # Dont worry about the client for an internal consuption
    	self.movements << Movement.new(
            :created_at=>User.current_user.today,
            :entity_id => self.order.vendor_id, 
            :comments => self.order.comments, 
            :product_id => self.product_id, 
            :quantity => -qty, 
            :movement_type_id => move, 
            :user_id => User.current_user.id,
            :order_id => self.id, 
            :serialized_product_id => old.serialized_product_id,
            :cost => cost, 
            :price => self.price,
            :cost_left => cost,
            :quantity_left => qty,
            :line_id => self.id
  	  )	
  	end
  	logger.debug "=======================-----------------------------self.cost set to #{self.cost}"
	end # prepare_movements
	#################################################################################################
	# Holds a copy of the old version of this object for reference
	# By storing it in a accessor, we'll never have to load it more than once
	#################################################################################################
  attr_accessor :old_version
	def old(attribute=nil)
		## logger.debug "running old"
		## logger.debug "attribute=#{attribute.to_s}"
	  if !self.old_version
	  	## logger.debug "CREATING COPY OF OLD"
	  	if !self.id
	  		## logger.debug "CANT RETURN OLD CAUSE I HAVENT BEEN SAVED AND DONT HAVE AN ID"
	    	return nil 
	    end
	    self.old_version=Line.find_by_id(self.id)
	  else
	  	## logger.debug "OLD ALREADY EXISTS"
	  end
	  if attribute
	  	if self.old_version
	  		## logger.debug "returning self.old_version.attributes[#{attribute}]"
      	return self.old_version.attributes[attribute] 
      else
      	## logger.debug "cant return #{attribute} cause we dont have an old version"
      end
    end
    return self.old_version
	end
	#################################################################################################
	# Validates the line and adds any errors it finds
	#################################################################################################
	def validate
#		if self.product.product_type_id == 1
#			if real_qty(self) != real_qty(old)
#				case self.order_type_id	# check inventory levels
#					when 1 # Venta     
#						### logger.debug "VALIDATING LINE: self=#{self.inspect}"
#						qty=order.vendor.inventory(self.product)
#						errors.add " ","Solo hay " + qty.to_s + " " + self.product.unit.name + " del producto " + self.product.name + " en el inventario"  if self.quantity > qty
#						#### logger.debug  "self.serialized_product=" + self.serialized_product.to_s if self.serialized_product
#						if self.product.serialized
#							if self.serialized_product
#									##### logger.debug  "self.serialized_product.location.id=" + self.serialized_product.location.id.to_s
#									#### logger.debug  "@order.vendor.id=" + @order.vendor.id.to_s
#									errors.add "El numero de serie " + self.serialized_product.serial_number + " no esta disponible en este sitio" if self.serialized_product.location != @order.vendor
#							else
#								errors.add "El numero de serie no se encuentra en el registro"
#							end
#						end
##						# Serial number should exist, and be in vendors location
#					when 2 # Compra
#						##### logger.debug  "validating Compra"
#						# Serial number may or may not exist
#						# if it does its location should be nil
#						# if not, it should be unqiue to the product, add it
#					when 3 # Transferencia
##						##### logger.debug  "validating Transferencia"
##						#### logger.debug  "order.vendor.inventory(self.product)=" + order.vendor.inventory(self.product).to_s
##						errors.add "no hay suficiente inventario del producto señalado" if self.quantity > order.vendor.inventory(self.product)	
##						errors.add "numero de serie no esta disponible en sitio señalado" if !self.serialized_product 
##						# Serial number should exist, and be in vendors location
#					when 5 # Devolucion de Venta
#						###### logger.debug  "validating Devolucion de Venta"
#						###### logger.debug  "self.product.id=" + self.product.id.to_s
#						#errors.add "insufficient stock" if self.quantity > order.client.inventory(self.product)
#						# Serial number should exist
#						# its location should be nil
##						# dont need to validate serial cause it was already validated
##					when 6 # Devolucion de Compra
##						##### logger.debug  "validating Devolucion de Compra"
##						errors.add "no hay suficiente inventario del producto señalado" if self.quantity > order.client.inventory(self.product)	
##						# Serial number should exist, and be in clients location
##						# dont need to validate serial cause it was already validated
##					when 7 # Devolucion de Transferencia	
##						##### logger.debug  "validating Devolucion de Transferencia"				
##						errors.add "no hay suficiente inventario del producto señalado" if self.quantity > order.client.location.inventory(self.product)
##						# Serial number should exist, and be in clients location
##						# dont need to validate serial cause it was already validated
#				end # case self.order_type_id
#			end # if real_qty(self) != real_qty(old)
#		end # if self.product.product_type_id == 1
	end # validate
  ##################################################################################################
  # Saves unsaved movements
  #################################################################################################
	def save_movements()
  	logger.debug "=======================-----------------------------self.cost set to #{self.cost}"
	  for item in self.movements
	  	if item
    	  item.order=self.order
	  	  if !item.id or update
				  if !item.save
				    for field, msg in item.errors
				      self.errors.add field, msg
				    end # for field, msg in item.errors
				  end # if !item.save and include_errors
				end # if !item.id or update
			end # if item
	  end # for item in list
  	logger.debug "=======================-----------------------------self.cost set to #{self.cost}"
	end # def save_related
	###################################################################################
	# Returns the revenue account where the value of the order should appear
	# This could be in different accounts depending on the prefrences set up in the prferences table
	# and depending on the values set on the different objects involved
	###################################################################################
	def revenue_account(order=self.order)
		for pref in Preference.find(:all, :order=>'value', :conditions=>"pref_group='revenue'")
			### logger.debug "Trying " + pref.name
			case pref.id
			when 1 #Product
				#### logger.debug " Grabbing revenue account from Product"
				return product.revenue_account if product.revenue_account
			when 2 #Category
				#### logger.debug " Grabbing revenue account from Category"
				if product.product_category
					return product.product_category.revenue_account if product.product_category.revenue_account
				end
			when 3 #Vendor
				#### logger.debug " Grabbing revenue account from Vendor"
				if product.vendor
					return product.vendor.revenue_account if product.vendor.revenue_account
				end
			when 4 #Site
				#### logger.debug " Grabbing revenue account from Site"
				if order.vendor
					return order.vendor.revenue_account if order.vendor.revenue_account
				end
			when 5 #Clients Rep
				#### logger.debug " Grabbing revenue account from Clients Rep"
				if order.client
					if order.client.user
						return order.client.user.revenue_account if order.client.user.revenue_account
					end
				end
			when 6 #Current User
				#### logger.debug " Grabbing revenue account from Current User"
				return User.current_user.revenue_account if User.current_user.revenue_account
			end
		end
		# If there are no other valid options, use the sites revenue account
		return order.vendor.revenue_account
	end

#######################################################################################################
# DEPRECATED # DEPRECATED # DEPRECATED # DEPRECATED # DEPRECATED # DEPRECATED # DEPRECATED # DEPRECATED
#######################################################################################################
# Now we will only handle full prices and costs.
#######################################################################################################
#	###################################################################################
#	# Returns the total price of the products on this line
#	###################################################################################
#	def total_cost
#	  return (self.cost||0) * (self.quantity||0)
##	  if order_type_id==Order::COUNT 
##	    total = (product.cost(self.order.client.site) ||0) * quantity
##	  elsif order_type_id==Order::PURCHASE
##	    total = (product.cost(self.order.vendor) ||0) * quantity
##	  else
##	    total = (product.cost(self.order.vendor) ||0) * quantity
##	  end
##		return total
#	end
#######################################################################################################
# DEPRECATED # DEPRECATED # DEPRECATED # DEPRECATED # DEPRECATED # DEPRECATED # DEPRECATED # DEPRECATED
#######################################################################################################
## Now we will only handle full prices and costs.
########################################################################################################
#  ###################################################################################
#	# Returns the total price of the products on this line
#	###################################################################################
#	def total_price
#		if order_type_id==Order::COUNT 
#			return 0 if !self.quantity
##			puts "self.price=#{self.price.to_s}"
##			puts "self.quantity=#{self.quantity.to_s}"
##			puts "self.previous_qty=#{self.previous_qty.to_s}"
##			puts "((self.quantity || 0) - (self.previous_qty || 0))=#{((self.quantity || 0) - (self.previous_qty || 0)).to_s}"
##			puts "self.price * ((self.quantity || 0) - (self.previous_qty || 0))=#{(self.price * ((self.quantity || 0) - (self.previous_qty || 0))).to_s}"
#			return self.price * ((self.quantity || 0) - (self.previous_qty || 0))
#		elsif order_type_id==Order::LABELS
#			return 0
#		else
#			## logger.debug "CALCULATING TOTAL PRICE &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&7"
#			## logger.debug "price=#{price.to_s}"
#			## logger.debug "warranty_price=#{warranty_price.to_s}"
#			## logger.debug "quantity=#{quantity.to_s}"
#			## logger.debug "((price ||0) + (warranty_price || 0)) * (quantity || 0)=#{(((price ||0) + (warranty_price || 0)) * (quantity || 0)).to_s}"
#			return ((price ||0) + (warranty_price || 0)) * (quantity || 0)
#			## logger.debug "total=#{total.to_s}"
#		end
#	end

    #######################################################################################
    # A Note on prices terminology:
    #######################################################################################
    # "price" and "cost" and "tax" are the total values for the quantity specified
    # "with tax" means the value includes tax
    # "full" means it includes tax and warranty
    # "unit" means its been divided per unit
    #######################################################################################
	#################################################################################################
	# Returns the amount of tax per unit
	#################################################################################################
	def tax	
		if self.order
			if self.order.client
				if self.order.client.entity_type_id == Entity::CREDITO_FISCAL or self.order.client.entity_type_id == Entity::SITE
					return self.price * TAX
				end
			end
		end
		return 0
	end
	###################################################################################
	# Returns the total price of the products on this line plus tax
	###################################################################################
	def price_with_tax
		return (self.price||0) + (self.tax||0)
	end
	###################################################################################
	# Returns the price of a single item
	###################################################################################
	def unit_price
	    if (self.quantity||0) > 0
		    return (self.price||0) / (self.quantity||0)
		else
		    return 0
		end
	end
	###################################################################################
	# Sets the price of a line using a single price
	###################################################################################
	def unit_price=(value)
	    if (self.quantity||0) > 0
		    self.price = (value||0) * (self.quantity||0)
		else
		    self.price = value
		end
	end
	###################################################################################
	# Returns the cost of a single item
	###################################################################################
	def unit_cost
	    if (self.quantity||0) > 0
		    return (self.cost||0) / (self.quantity||0)
		else
		    return 0
		end
	end
	
	###################################################################################
	# Returns the price of a single item
	###################################################################################
	def unit_cost=(value)
	    if (self.quantity||0) > 0
		    self.cost = (value||0) * (self.quantity||0)
		else
		    self.cost = value
		end
	end
	###################################################################################
	# Returns the total price of the products on this line plus tax
	###################################################################################
	def full_unit_price
		return (price ||0) + (warranty_price || 0) * (1+TAX)
	end
	def format_unit_price
		return '$' + ("%5.2f" % self.unit_price).strip
	end
	def format_unit_price=(p)
		self.unit_price=p.gsub(',','_').gsub('$','_').to_f
	end
	def format_price
		return '$' + ("%5.2f" % self.price).strip
	end
	def format_price=(p)
		self.price=p.gsub(',','_').gsub('$','_').to_f
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
		#### logger.debug "str=#{str.to_s}"
		if str=="" or str=="no" or str=="No" or str=="NO"
			#### logger.debug "setting to no"
			self.isreceived = 0
		else
			self.isreceived = 1
			#### logger.debug "setting to yes"
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
		### logger.debug "setting isreceived on line"
		### logger.debug "self.order.void=#{self.order.void.to_s}"
		if checkbox.to_i==1 and !self.order.void
			if self.received == nil
				self.received=(User.current_user.today || Time.now)
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
		if (!(serial == "" or serial == "\n") and ((self.order_type_id==2) or (self.order_type_id==5)))
			### logger.debug "Taking create path"
			s=SerializedProduct.find_or_create_by_serial_number(serial)
			if s.product_id==nil
				### logger.debug "self.product_id=#{self.product_id.to_s}"
				s.update_attribute(:product_id, self.product_id)
			end   
		else
			### logger.debug  "taking find path"
			s=SerializedProduct.find_by_serial_number(serial)
		end
		s=nil if self.order.void
		if self.order_type_id == 5
			self.serialized_product=s
			### logger.debug "Skipping creating movements cause this is a count"
		else
			if self.serialized_product # the line was already marked as delivered
				### logger.debug  "the line was already marked as delivered"
				if !(serial == "" or serial == "\n")
					if s != self.serialized_product # only need to work if it's been changed
						### logger.debug  "we are changing the serial numbers delivered for the line"
						# we are changing the serial numbers delivered for the line
						# because it is an existing order, we can create the movements now.
				
						# This is a Compra(2), Venta(1), o Transaccion(3)
				
						self.isreceived=0
						self.serialized_product = s
						self.isreceived=1
					end
				else # we are marking the line as not delivered after it was previously delivered
					### logger.debug  "we are marking the line as not delivered after it was previously delivered"
			
					# This is a Devolucion of Compra(6), Venta(5), o Transaccion(7)
					### logger.debug  "setting isreceived=0"
					self.isreceived=0
					self.serialized_product = nil # s was also nil
				end
			else # the line was previously undelivered
				#### logger.debug  "the line was previously undelivered"
				if !(serial == "" or serial == "\n")
					### logger.debug  "delivering previously undelivered serial"
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
