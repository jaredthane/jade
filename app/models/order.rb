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

# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class Order < ActiveRecord::Base
	has_many :lines, :dependent => :destroy
	has_many :products, :through => :lines
	has_many :payments
	has_many :movements
	belongs_to :order_type
	HUMANIZED_ATTRIBUTES = {
    :user => "Usuario",
    :ordered => "Fecha de Solicitud",
    :vendor => "Proveedor",
    :client => "Cliente"
  }
  def self.human_attribute_name(attr)
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
  def validate
  	#puts "validating order"
  end
	after_update :save_lines
	after_create :create_lines
	after_update :check_for_discounts
	after_create :check_for_discounts
	belongs_to :vendor, :class_name => "Entity", :foreign_key => 'vendor_id'
	belongs_to :client, :class_name => "Entity", :foreign_key => 'client_id'
	validates_presence_of(:vendor, :message => "debe ser valido")
	validates_presence_of(:client, :message => "debe ser valido")
	#validates_associated :lines
	belongs_to :user
	validates_presence_of(:user, :message => "debe ser valido")
	
  ###################################################################################
	# Returns an array of all of the discounts in the system
	###################################################################################
	def get_discounts
  	product_type=ProductType.find(2)
    @discounts = product_type.products.find(:all, :order => "name")
  end
  
  ###################################################################################
	# Returns total quantity of an item contained in this order
	###################################################################################
  def get_sum(product)
  	sum=0
  	o=Order.find(self.id)
  	#puts "num lines: " + o.lines.count.to_s
  	for line in o.lines
  		#puts "checking line#" + line.id.to_s
  		if line.product.id==product.id
  			#puts "found some"
  			sum+=line.quantity
  		end
  	end
  	return sum
  end
  
  ###################################################################################
	# Returns the number of times an order qualifies for a discount or 0 if it does not
	###################################################################################
  def discount_qualifies(discount)
  	
  	@qualify=10000
 		#Check if we have enough of each product
		for req in discount.requirements do        
			@wehave = get_sum(req.required)
			@weneed = req.quantity
#			puts "@wehave ->" + @wehave.to_s + "<-"
#			puts "@weneed ->" + @weneed.to_s + "<-"
			@temp = @wehave / @weneed
			
#			puts "@temp ->" + @temp.to_s + "<-"
#			puts "@qualify ->" + @qualify.to_s + "<-"
			@qualify= [@qualify, @temp].min
#			puts "@qualify ->" + @qualify.to_s + "<-"
		end #req in discount.requirements
		return nil if @qualify == 10000
  	return @qualify
  end
	
  ###################################################################################
	# Checks if the order qualifies for any discounts and adds lines for them ass necisary
	###################################################################################
  def check_for_discounts
#  	puts "checking existing discounts"
  	# Go through each discount in the order and see if it still qualifys
  	if self.order_type_id==1
			@discounts_in_order= []
			for line in self.lines.find(:all, 
																	:conditions => ' products.product_type_id = 2 ',
																	:joins => ' inner join products on lines.product_id=products.id ')
	#  		puts "checking " + line.product.name
				@discounts_in_order << line.product
				@qualify = discount_qualifies(line.product)
				if @qualify > 0
					# Set the quantity of this discount to the number of times we qualify
					line.quantity = @qualify
					line.save()
				else
					# Remove discount since we no longer qualify
					puts line.id.to_s
					self.lines.delete(line)
				end
			end
			# Go through each discount and see if the order qualifies
	#  	puts "checking new discounts"
			for discount in get_discounts do 
	#			puts "checking" + discount.name
				#make sure we dont add a discount thats already in the order
				if !@discounts_in_order.include?(discount)
					# make sure the discount is available in this site
					if discount.available
						puts discount.name + "available" 
						@qualify = discount_qualifies(discount)
						#If the order qualifies, add it.
						if @qualify >= 1			                     		
	#						puts "It Qualifies!!!!!!!!!!!!!!!!!!!"
							l=Line.new(:order_id => self.id, :product_id => discount.id, :quantity => @qualify, :price => discount.price, :received => 1)
							l.save
						end #if qualify==1
					end # if available
				end
			end #discount in get_discounts
		end # if this is a sale
	end #check_for_discounts
	

	###################################################################################
	# Returns the total price of all of the products in the order, not including tax
	###################################################################################
	def total_price
		total=0
		for l in self.lines
			total = total + (l.total_price)
		end
		return total
	end
	###################################################################################
	# Returns the total tax to be charged the user.
	###################################################################################
	def total_tax
		total=0
		for l in self.lines
			total = total + (l.tax)
		end
		return total
	end
	
	###################################################################################
	# Returns the total price of all of the products in the order plus tax
	###################################################################################
	def total_price_with_tax
		total=0
		if client
			if client.entity_type_id == 2
				for l in self.lines
					total = total + (l.total_price)
				end
			else
				for l in self.lines
					total = total + (l.total_price_with_tax)
				end
			end
		else
			for l in self.lines
				total = total + (l.total_price)
			end
		end
		return total
	end
	
	###################################################################################
	# Returns the total price of all of the products in the order with tax spelled out in spanish
	###################################################################################
	def total_price_with_tax_in_spanish
		return number_to_spanish(self.total_price_with_tax)
	end
	
	###################################################################################
	# Returns the total of all the payments made for this order
	###################################################################################
	def amount_paid
		return self.payments.sum(:presented)-self.payments.sum(:returned)
	end
	
	###################################################################################
	# Returns the name of the Vendor as a string
	###################################################################################
	def vendor_name
		vendor.name if vendor
	end
	
	###################################################################################
	# Receives a string and sets the vendor_id for the product to the entity with that name
	###################################################################################
	def vendor_name=(name)
		self.vendor = Entity.find_by_name(name) unless name.blank?
	end
	###################################################################################
	# Returns the name of the Client as a string
	###################################################################################
	def client_name
		client.name if client
	end
	###################################################################################
	# Receives a string and sets the client_id for the product to the entity with that name
	###################################################################################
	def client_name=(name)
		logger.debug "saving order"
		if !name.blank?
			logger.debug "self.order_type_id=#{self.order_type_id.to_s}"
			if self.order_type_id == 1
				logger.debug "saving sale"
				find = Entity.find_all_by_name(name)
				if find.length > 0
					logger.debug "client was found"
					self.client = find[0]
				else
					logger.debug "client was not found"
					self.client = Entity.create(:entity_type_id => 2,:name=> name, :price_group_name_id =>User.current_user.price_group_name_id, :user_id =>User.current_user.id, :state_id => 12)
				end
			else
				self.client = Entity.find_by_name(name)
			end
		end
	end
	###################################################################################
	# Returns the name of the user as a string
	###################################################################################
	def user_name
		user.login if user
	end
	###################################################################################
	# Receives a string and sets the user_id for the product to the user with that name
	###################################################################################
	def user_name=(name)
		self.user = User.find_by_login(name) unless name.blank?
	end
	
#	def order_type
#		if self.client.id==1
#			return 'internal'
#		end
#		if self.vendor.entity_type.id == 3 
#			 if self.client.entity_type.id == 3 
#				 'transfers' 
#			 else 
#				 'sales' 
#			 end 
#		else 
#			 if self.client.entity_type.id == 3 
#				 'purchases' 
#			 else 
#				 'other' 
#			 end 
#		 end
#	end
	###################################################################################
	# Posts a physical count, saving previous qtys, creating movements, updating inventories and costs
	###################################################################################
	def post
		products_done = []
		logger.debug "======================Starting to post ======================================"
		logger.debug "self.lines=#{self.lines.inspect}"
		for line in self.lines
			logger.debug "posting line=#{line.inspect}"
			if !products_done.include?(line.product)
				logger.debug "its product has not been posted yet"
				if line.product.serialized
					logger.debug "the product is serialized"
					#Get a complete list of the lines in the order for this product
					product_lines= []
					for l in self.lines
						product_lines << l if l.product = line.product
					end
					
					logger.debug "product_lines=#{product_lines.inspect}" 
					# Add new serials
					for l in product_lines
						logger.debug "l=#{l.inspect}"
#						logger.debug "l.serialized_product.new_record?=#{l.serialized_product.new_record?.to_s}"
						old_loc = l.serialized_product.location
						logger.debug "old_loc=#{old_loc.inspect}"
						if old_loc # make sure it has a location, might have just been created
							logger.debug "old_loc existes"
							logger.debug "self.vendor_id=#{self.vendor_id.to_s}"
							logger.debug "old_loc.id=#{old_loc.id.to_s}"
							if old_loc.id != self.vendor_id # It was not already here
								logger.debug "old_loc.id != self.vendor_id"
								if old_loc.entity_type== 3 # It was in a different site
									logger.debug "old_loc.entity_type== 3"
									# Make a movement to take it out of the other site
									Movement.create(:entity_id => old_loc.id, :comments => self.comments, :product_id => l.product_id, :quantity => -1, :movement_type_id => 4, :user_id => User.current_user.id,:order_id => self.id, :line_id => l.id, :serialized_product_id => l.serialized_product.id)
									i=l.product.inventories.find_by_entity_id(old_loc.id)
									i.quantity=i.quantity-1
									i.save
								end
								logger.debug "Make a movement to bring it here"
								# Make a movement to bring it here
								Movement.create(:entity_id => self.vendor_id, :comments => self.comments, :product_id => l.product_id, :quantity => 1, :movement_type_id => 4, :user_id => User.current_user.id,:order_id => self.id, :line_id => l.id, :serialized_product_id => l.serialized_product.id)
								i = l.product.inventories.find_by_entity_id(self.vendor_id)
								l.previous_qty = i.quantity
								i.quantity=i.quantity+1
								i.save
							end
						else	# This serial was just created
							logger.debug "# This serial was just created"
								# Make a movement to put it here
								Movement.create(:entity_id => self.vendor_id, :comments => self.comments, :product_id => l.product_id, :quantity => 1, :movement_type_id => 4, :user_id => User.current_user.id,:order_id => self.id, :line_id => l.id, :serialized_product_id => l.serialized_product.id)
								i = l.product.inventories.find_by_entity_id(self.vendor_id)
								l.previous_qty = i.quantity
								i.quantity=i.quantity+1
								i.save
						end
					end
					#Remove missing serials
					logger.debug "Remove missing serials"
					serials=[]
					for l in product_lines
						serials << l.serialized_product
					end
					logger.debug "serials=#{serials.inspect}"
					for s in line.product.get_serials_here(self.vendor_id)
						logger.debug "s=#{s.inspect}"
						if !serials.include?(s)
							logger.debug "!serials.include?(s)"
							# Make a movement to remove it from here
							Movement.create(:entity_id => self.vendor_id, :comments => self.comments, :product_id => s.product_id, :quantity => -1, :movement_type_id => 4, :user_id => User.current_user.id,:order_id => self.id, :line_id => l.id, :serialized_product_id => s.id)
							i = s.product.inventories.find_by_entity_id(self.vendor_id)
							l.previous_qty = i.quantity
							i.quantity=i.quantity-1
							i.save
							# Make movement to move it to Internal Consumption
							Movement.create(:entity_id => 1, :comments => self.comments, :product_id => s.product_id, :quantity => 1, :movement_type_id => 4, :user_id => User.current_user.id,:order_id => self.id, :line_id => l.id, :serialized_product_id => s.id)
						end
					end
				else
					if line.quantity != line.product.quantity
						m=Movement.create(:entity_id => self.vendor_id, :comments => self.comments, :product_id => line.product_id, :quantity => line.quantity - line.product.quantity, :movement_type_id => 4, :user_id => User.current_user.id,:order_id => self.id, :line_id => line.id)
						i=line.product.inventories.find_by_entity_id(self.vendor_id)
						line.previous_qty = i.quantity
						i.quantity=line.quantity
						i.save
						line.product.cost=line.product.calculate_cost
						products_done << line.product
					end
				end
			end
		end
	end
	def save_lines
		puts "saving lines"
		lines.each do |line|
			line.save(false)
		end
	end
	def create_lines
		#puts "creating lines"
		lines.each do |line|
			#puts "setting order_id to " + self.id.to_s
			line.order_id = self.id 
			line.save(true)
		end		
	end
	def last_received
		##puts "Checking for order number "+self.id.to_s
		@received=nil
		for line in self.lines do
			return nil if line.received == nil
			if @received == nil
				@received=line.received
				##puts line.product.name + " was received " + line.received.to_s + " 2received set to "+@received.to_s
			else 
				if line.received > @received
					##puts line.product.name + " was received " + line.received.to_s + " received is already "+@received.to_s
					@received=line.received
					##puts line.product.name + " was received " + line.received.to_s + " 1received set to "+@received.to_s
				end
			end
		end
		return @received
	end
	
	def self.search(search, page)
		paginate :per_page => 20, :page => page,
						 :conditions => ['(vendors.name like :search OR clients.name like :search OR orders.id like :search) AND (vendors.id=:current_location OR clients.id=:current_location)', {:search => "%#{search}%", :current_location => "#{User.current_user.location_id}"}],
						 :order => 'created_at desc',
						 :joins => "inner join entities as vendors on vendors.id = orders.vendor_id inner join entities as clients on clients.id = orders.client_id"
	end
	def self.search_by_rights(search, page)
		search=search||''
		conditions = "vendors.name like '%" + search + "%' OR clients.name like '%" + search + "%' OR orders.id like '%" + search + "%') AND (vendors.id=" + User.current_user.location_id.to_s + " OR clients.id =" + User.current_user.location_id.to_s
		conditions += ' AND order_type_id != 2' if !User.current_user.has_rights(['admin','gerente','compras'])
		conditions += ' AND order_type_id != 1' if !User.current_user.has_rights(['admin','gerente','ventas'])
		conditions += ' AND order_type_id != 3' if !User.current_user.has_rights(['admin','gerente','compras','ventas'])
		paginate :per_page => 20, :page => page,
						 :conditions => conditions,
						 :order => 'created_at desc',
						 :joins => "inner join entities as vendors on vendors.id = orders.vendor_id inner join entities as clients on clients.id = orders.client_id"
	end
	def self.search_sales(search, page)
		paginate :per_page => 20, :page => page,
						 :conditions => ['(vendors.entity_type_id = 3 and clients.name like :search) AND (vendors.id=:current_location OR clients.id=:current_location) AND (clients.id != 1)', {:search => "%#{search}%", :current_location => "#{User.current_user.location_id}"}],
						 :order => 'created_at desc',
						 :joins => "inner join entities as vendors on vendors.id = orders.vendor_id inner join entities as clients on clients.id = orders.client_id"
	end
	def self.search_purchases(search, page)
		paginate :per_page => 20, :page => page,
						 :conditions => ['(vendors.name like :search and clients.entity_type_id = 3) AND (vendors.id=:current_location OR clients.id=:current_location)', {:search => "%#{search}%", :current_location => "#{User.current_user.location_id}"}],
						 :order => 'created_at desc',
						 :joins => "inner join entities as vendors on vendors.id = orders.vendor_id inner join entities as clients on clients.id = orders.client_id"
	end
	def self.search_internal(search, page)
		paginate :per_page => 20, :page => page,
						 :conditions => ['vendors.name like :search AND orders.client_id = 1 AND orders.vendor_id=:current_location', {:search => "%#{search}%", :current_location => "#{User.current_user.location_id}"}],
						 :order => 'created_at desc',
						 :joins => "inner join entities as vendors on vendors.id = orders.vendor_id"
	end
	def self.search_physical_counts(search, page)
		paginate :per_page => 20, :page => page,
						 :conditions => ['(location.id=:current_location) AND (orders.order_type_id = 5)', {:search => "%#{search}%", :current_location => "#{User.current_user.location_id}"}],
						 :order => 'created_at desc',
						 :joins => "inner join entities as location on location.id = orders.vendor_id"
	end
	def self.search_batch(search, page)
		paginate :per_page => 20, :page => page,
						 :conditions => ['(last_batch=True) AND (vendors.name like :search OR clients.name like :search OR orders.id like :search) AND (vendors.id=:current_location OR clients.id=:current_location)', {:search => "%#{search}%", :current_location => "#{User.current_user.location_id}"}],
						 :order => 'created_at desc',
						 :joins => "inner join entities as vendors on vendors.id = orders.vendor_id inner join entities as clients on clients.id = orders.client_id"
	end
	def tens_to_spanish(num)
#		puts "received:" + num.to_s
		case num
			when 20
#				puts "returning veinte"
				return 'veinte'
			when 30
				return 'treinta'
			when 40
				return 'cuarenta'
			when 50
				return 'cincuenta'
			when 60
				return 'sesenta'
			when 70
				return 'setenta'
			when 80
				return 'ochenta'
			when 90
				return 'noventa'
			else
				return ''
		end
	end
	def hundreds_to_spanish(num)
		# handles only hundreds place
#		puts "received:" + num.to_s
		case num
			when 100
				return 'ciento'
			when 200
				return 'doscientos'
			when 300
				return 'trescientos'
			when 400
				return 'cuatrocientos'
			when 500
				return 'quinientos'
			when 600
				return 'seiscientos'
			when 700
				return 'setecientos'
			when 800
				return 'ochocientos'
			when 900
				return 'novecientos'
			else
				return ''
		end
	end
	def number_to_spanish (num)
 		# depends on tens_to_spanish(num) and hundreds_to_spanish() and number_to_spanish() 
 		# to handle  numbers 0-999,999,999
		answer=""
		millions = digits_to_spanish((num/1000000).to_i)		
		thousands = digits_to_spanish((num/1000).to_i%1000)
		ones = digits_to_spanish((num%1000).to_i)
		cents = digits_to_spanish((num*100).to_i%100)
		answer = millions + ' milliones,' if (num/1000000).to_i > 1
		answer = 'un million,' if (num/1000000).to_i == 1
		answer += ' ' if answer != '' and (num/1000).to_i%1000 > 0
		answer += thousands + ' mil,' if (num/1000).to_i%1000 > 0
		answer += ' ' if answer != '' and (num%1000).to_i > 0
		answer += ones + ' dolares' if (num%1000).to_i > 1
		answer += 'un dolar' if (num%1000).to_i == 1
		answer = 'cero dolares' if answer == '' or answer == nil
		answer += ' con un centavo' if (num*100).to_i%100 == 1
		answer += ' con '+ cents + ' centavos' if (num*100).to_i%100 > 1
		return answer
	end
	def digits_to_spanish(num)
		if num == 100
			return 'cien'
		end
 		# depends on tens_to_spanish(num) and hundreds_to_spanish() to handle  numbers 1-999
		answer = hundreds_to_spanish((num/100).to_i%10*100)
		answer += ' ' if answer != '' and (num%100 > 0)
		answer += tens_to_spanish((num/10).to_i%10*10) if ((num%100).to_i > 19)
		answer += ' y ' if ((num/10).to_i%10*10 > 19) and (num%10 > 0)
		if (num%100).to_i < 20
			answer += ones_to_spanish((num%100).to_i)
		else
			answer += ones_to_spanish((num%10).to_i)
		end
		#answer = 'cero' if answer == ''
	end
	def ones_to_spanish (num)
	
		case num
			when 1
				return 'un'
			when 2
				return 'dos'
			when 3
				return 'tres'
			when 4
				return 'cuatro'
			when 5
				return 'cinco'
			when 6
				return 'seis'
			when 7
				return 'siete'
			when 8
				return 'ocho'
			when 9
				return 'nueve'
			when 10
				return 'diez'
			when 11
				return 'once'
			when 12
				return 'doce'
			when 13
				return 'trece'
			when 14
				return 'catorse'
			when 15
				return 'quince'
			when 16
				return 'dieciseis'
			when 17
				return 'dieciseite'
			when 18
				return 'dieciocho'
			when 19
				return 'diecinueve'
			else
				return ''
		end
	end
end
