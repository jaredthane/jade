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

class Order < ActiveRecord::Base
	has_many :lines, :dependent => :destroy
	has_many :products, :through => :lines
	has_many :payments
	has_many :movements
	has_many :transactions, :class_name => "Trans"
	belongs_to :order_type
	belongs_to :next_order, :class_name => "Order", :foreign_key => 'next_order'
  SALE=1
  PURCHASE=2
  INTERNAL=3
  TRANSFER=4
  COUNT=5
	##################################################################################################
	# 
	#################################################################################################
  def validate
  	puts "validating order<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    errors.add "Cliente"," no es válido" if !client
    errors.add "Proveedor"," no es válido" if !vendor
    errors.add "Debe ingresarse al sistema antes de hacer cambios","" if !user
  end
  
	belongs_to :vendor, :class_name => "Entity", :foreign_key => 'vendor_id'
	belongs_to :client, :class_name => "Entity", :foreign_key => 'client_id'
	#validates_associated :lines
	belongs_to :user
		
	##################################################################################################
	# Is run immediatly after a new order is created or updated
	#################################################################################################
  # checking for discounts should be done before saving lines
  # Calculating total must be done after lines have been updated 
  #     (This is true but the updating of the lines is done before pre_save)
  # Creating transactions must be done after Calculating total
  ####################################################################################
  before_save :pre_save
  def pre_save
		logger.debug "pre_save"
    if self.deleted
      self.grand_total = 0
    else
  	  self.grand_total = self.total_price_with_tax
  	end
		logger.debug "post_save"
	  split_over_sized_order
	  check_for_discounts
	  logger.info "Dumping lines before save"
	  logger.info self.lines.inspect
	  m = main_transaction
	  i = inventory_transaction
	  self.transactions << m if m
	  self.transactions << i if i
  end
  
	after_save :post_save
	def post_save
	  save_related(lines, true)
	  logger.info "Dumping lines after save"
	  logger.info self.lines.inspect
	  
	  save_related(movements, true)
	  save_related(transactions, true)
	end
	
	##################################################################################################
	# Will split a large order into smaller ones; works recursively
	#################################################################################################
	def split_over_sized_order
	  if lines.length > MAX_LINES_PER_ORDER and MAX_LINES_PER_ORDER > 0
	    self.next_order = Order.new(self.attributes)
      for line in self.lines[MAX_LINES_PER_ORDER..-1]
        self.next_order.lines << Line.new(line.attributes)
      end
	    self.next_order.save
      self.lines=self.lines[0..MAX_LINES_PER_ORDER-1]	    
	  end
	end
  ##################################################################################################
  # Receives a list of related objects and saves them
  # Can be used for movements, transactions, lines, or other objects
  # Set update=true if you want it to save existing objects (like for updating lines)
  #################################################################################################
	def save_related(list, update=false, include_errors=true)
	  for item in list
	  	if item
    	  item.order_id=self.id
	  	  if !item.id or update
				  if !item.save and include_errors
				    for field, msg in item.errors
				      self.errors.add field, msg
				    end # for field, msg in item.errors
				  end # if !item.save and include_errors
				end # if !item.id or update
			end # if item
	  end # for item in list
	end # def save_related
	##################################################################################################
	# Sets receipt number as well as the receipts filname and date generated
	#################################################################################################
  def number=(num)
    self.receipt_number=num
    self.receipt_generated=Time.now
  end
	##################################################################################################
	# Returns receipt number
	#################################################################################################
  def number
    return receipt_number
  end
	##################################################################################################
	# This function is to complement markreceived so we can set the received date on an order and its 
	# lines but have the widget stay null by default
	#################################################################################################
	def markreceived
		return nil
	end
	##################################################################################################
	# This function is to complement markreceived so we can set the received date on an order and its 
	# lines but have the widget stay null by default
	#################################################################################################
	def markreceived=(fecha)
	  puts "saving fecha######################################################"
		#puts "fecha:" + fecha.to_s
		if fecha
			if fecha != ""
				self.received = fecha
				for line in lines
					line.received = fecha
					line.save
				end
			end
		end
	end
	
	#################################################################################################
	# Holds a copy of the old version of this object for reference
	# By storing it in a accessor, we'll never have to load it more than once
	#################################################################################################
	attr_accessor :old_version
	def old(attribute=nil)
	  return nil if !self.id
    self.old_version=Order.find_by_id(self.id)if !self.old_version
    return self.old_version.attributes[attribute] if attribute
    return self.old_version
	end
	#################################################################################################
	# Returns a Dictionary of the lines on the order with ids as keys.
	# Used by lines=() to save lines effeciently
	#################################################################################################
	def indexed_lines
	  i={}
	  for l in lines
	    i[l.id]=l
	  end
	end
	#################################################################################################
	# Returns a revision of a transaction with the Credit and Debit Posts Reversed
	#################################################################################################
	def reverse_transaction(t)
	  if t
	    t.tipo='Cancelacion de ' + t.tipo
		  for p in t.posts
			  if p.post_type_id==Post::DEBIT
				  p.post_type_id=Post::CREDIT
			  else
				  p.post_type_id=Post::DEBIT
			  end
		  end
		end
		return t
	end
	#################################################################################################
	# Adds a transaction to reflect the creation of the order if necissary
	#################################################################################################
	def main_transaction(date=User.current_user.today)
		if old
		  amount = self.grand_total - old.grand_total 
		else
			amount = self.grand_total
		end
	  if amount != 0
	    tax = self.total_tax - (old('total_tax') || 0)
		  case order_type_id
		  when 1 #Venta
			  sale=Trans.new(:user=>User.current_user,:created_at=>date, :tipo=> order_type.name)
        sale.posts << Post.new(:account => self.client.cash_account,:created_at=>date, :value=>amount, :post_type_id =>Post::DEBIT)
        if tax != 0
        	sale.posts << Post.new(:account => self.vendor.tax_account,:created_at=>date, :value=>tax, :post_type_id =>Post::CREDIT)
        end
        revenue_accts={}
        for line in self.lines
        	r=line.revenue_account(self).id
        	price = line.total_price - (line.old('total_price') || 0)
        	if revenue_accts[r]
        		revenue_accts[r] += price
        	else
        		revenue_accts[r] = price
        	end
        end
        revenue_accts.each { |key, value| 
        	acct= Account.find(key)
				  sale.posts << Post.new(:account => acct, :value=>value,:created_at=>date, :post_type_id =>Post::CREDIT)
			  }    
			  return sale
		  when 2 # Compra
	      purchase = Trans.new(:user=>User.current_user,:created_at=>date, :tipo=> order_type.name)
	      purchase.posts << Post.new(:account => self.vendor.cash_account,:created_at=>date, :value => amount, :post_type_id =>Post::CREDIT)
        purchase.posts << Post.new(:account => self.client.inventory_account,:created_at=>date, :value => amount, :post_type_id =>Post::DEBIT)
			  return purchase
      end
    end
    return nil
	end
	###################################################################################
	# Returns total quantity of an item contained in this order
	###################################################################################
  def inventory_value
  	sum=0
  	for line in self.lines
  		if line.product.product_type_id==1
  			sum+=line.product.cost*line.quantity
  		end
  	end
  	return sum
  end
	###################################################################################
	# Returns transaction for inventory movement if any is necissary
	###################################################################################
	def inventory_transaction(date=User.current_user.today)
		return nil if order_type_id == COUNT
		inventory_cost = self.inventory_value - (old('inventory_value')||0)
    if inventory_cost != 0
    	inventory = Trans.new(:user=>User.current_user,:created_at=>date, :tipo=> 'Inventario de ' + order_type.name)
	    inventory.posts << Post.new(:account => self.vendor.inventory_account,:created_at=>date, :value=>inventory_cost, :post_type_id =>Post::CREDIT)
	    inventory.posts << Post.new(:account => self.vendor.expense_account,:created_at=>date, :value=>inventory_cost, :post_type_id =>Post::DEBIT)
	  end
	  return inventory
	end
  ###################################################################################
  # updates existing lines on the order, adds new ones and deletes missing ones. DOES NOT SAVE THEM
  ##################################################################################
	def lines=(lines)
		logger.debug "Saving lines"
	  i={}
	  for l in self.lines
	    i[l.id]=l
	  end
    for l in (lines[:new]||[])
	  	if l[:delete_me]!='1'
	      line=self.lines.new()
	      line.order=self
	      line.attrs=l
	      logger.debug "line.order_type_id=#{line.order_type_id.to_s}"
	      self.lines << line
	    end
    end
    for key, l in (lines[:existing]||[])
    	if line = i[l[:id].to_i]
	      line.order=self
    		logger.debug "l[:order_type_id]=#{l[:order_type_id].to_s}"
    		line.attrs=l
    		logger.debug "line.order_type_id=#{line.order_type_id.to_s}"
      	line.destroy if l[:delete_me]=='1' #<------------ Not sure if this will work right. It needs to stick, but cancel if theres errors
                                         # ALSO: NEED TO DO ACCOUNTING AND INVENTORY ON THIS LINE!!!!!
      end # if line = i[l[:id].to_i]
    end # for l in lines
  end #lines=(lines)

  ###################################################################################
  # Returns an array of all of the discounts in the system
  ##################################################################################
  def get_discounts
  	product_type=ProductType.find(2)
    @discounts = product_type.products.find(:all, :order => "name")
  end
  
  ###################################################################################
	# Returns total quantity of an item contained in this order
	###################################################################################
  def product_qty(product)
  	sum=0
  	o=Order.find(self.id)
  	## ###puts "num lines: " + o.lines.count.to_s
  	for line in o.lines
  		## ###puts "checking line#" + line.id.to_s
  		if line.product.id==product.id
  			## ###puts "found some"
  			sum+=line.quantity
  		end
  	end
  	return sum
  end
  
  ###################################################################################
	# Returns the number of times an order qualifies for a discount or 0 if it does not
	###################################################################################
  def discount_qualifies(discount)
  	qualify=nil
	  #Check if we have enough of each product
	  for req in discount.requirements do        
		  wehave = product_qty(req.required)
		  weneed = req.quantity
		   #puts "wehave ->" + wehave.to_s + "<-"
		   #puts "weneed ->" + weneed.to_s + "<-"
		  temp = wehave / weneed
		
		   #puts "temp ->" + temp.to_s + "<-"
		   #puts "qualify ->" + qualify.to_s + "<-"
		  if qualify
		    qualify= [qualify, temp].min
		  else
		    qualify=temp
		  end
		  # ###puts "qualify ->" + qualify.to_s + "<-"
	  end #req in discount.requirements
	  return 0 if !qualify
    return qualify
  end
	
  ###################################################################################
	# Checks if the order qualifies for any discounts and adds lines for them as necisary
	# Also modifies quantities of existing discounts or even removes them if tey no longer qualify
	###################################################################################
  def check_for_discounts
  	#puts "checking existing discounts <============================================================================="
  	# Go through each discount in the order and see if it still qualifys
  	# ###puts "self.order_type_id"+(self.order_type_id==1).to_s
  	if self.order_type_id==1
			# Go through each discount and see if the order qualifies
			for discount in get_discounts do 
			  qualify = discount_qualifies(discount)
				if line=self.lines.find_by_product_id(discount.id)
				  # this discounts already on the order
  				if qualify > 0
  					# Set the quantity of this discount to the number of times we qualify
  					line.quantity = qualify
  				else
  					# Remove discount since it no longer qualifys
  					line.destroy
  				end
				else
					# make sure the discount is available in this site
					if discount.available
						# If the order qualifies, add it.
						if qualify > 0		                     		
							self.lines << Line.new(:order_id => self.id, :product_id => discount.id, :quantity => qualify, :price => discount.price, :received => 1,:created_at=>User.current_user.today)
						end #if qualify > 0	
					end # if available
				end # if self.products.include?(discount)
			end # for discount in get_discounts
		end # if this is a sale
	end # check_for_discounts
	###################################################################################
	# Returns the receipt number as string or 'Sin Numero' if its null
	###################################################################################
	def receipt
		return receipt_number if receipt_number
		return "Sin Numero"
	end
	###################################################################################
	# Returns the total price of all of the products in the order, not including tax
	###################################################################################
	def total_price
		total=0
		for l in self.lines
			total = (total||0) + (l.total_price||0)
		end
		return (total||0)
	end
  ###################################################################################
	# Returns the total cost of all of the products in the order
	###################################################################################
	def total_cost
		total=0
		for l in self.lines
			total = (total||0) + (l.total_cost||0)
		end
		return (total||0)
	end
	###################################################################################
	# Returns the total tax to be charged the user.
	###################################################################################
	def total_tax
		if client
			if client.entity_type_id == 2
				return 0
			else
				total=0
				for l in self.lines
					total = (total||0) + (l.tax||0)
				end
				return (total||0)
			end
		else
			return 0
		end
	end
	
	###################################################################################
	# Returns the total price of all of the products in the order plus tax
	###################################################################################
	def total_price_with_tax
		total=0
		if client
			if client.entity_type_id == 2
				for l in self.lines
					total = (total||0) + (l.total_price||0)
				end
			else
				for l in self.lines
					total = (total||0) + (l.total_price_with_tax||0)
				end
			end
		else
			for l in self.lines
				total = (total||0) + (l.total_price||0)
			end
		end
		return (total||0)
	end
	##################################################################################################
	# Creates a payment equal to the total amount due on the order
	# The payment model will do the accounting
	#################################################################################################
	def pay_off()
	  if grand_total > amount_paid
  	  Payment.create(:order=>self, :amount=>grand_total-amount_paid, :payment_method_id=>1, :user=>User.current_user, :presented=>grand_total-amount_paid, :created_at=>User.current_user.today)
    end
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
	  puts "name=" + name.to_s
		if !name.blank?
	    puts "name(not blank)=" + name.to_s
			self.client = Entity.find_by_name(name)
			if !self.client
			  self.client = Entity.create(:entity_type_id => 2,:name=> name, :price_group_name_id =>User.current_user.price_group_name_id, :user_id =>User.current_user.id, :state => State.first)
			end
		end
	end
	def attrs=(a)
		logger.debug "Saving VOID"
		self.void=a[:void]
		logger.debug "Saving Other values"
		self.attributes=a
	end
	###################################################################################################
	# Simple mathematic function that returns 1 if the value is positive, -1 if its negative 0 if its zero
	#################################################################################################
	def pos_neg(x)
		return x/x.abs if x!=0
	end
	###################################################################################
	# Posts a physical count, saving previous qtys, creating movements, updating inventories and costs
	###################################################################################
	def post
		products_done = []
		date=User.current_user.today
		logger.debug "======================Starting to post ======================================"
#		logger.debug "self.lines=#{self.lines.inspect}"
		for line in self.lines
			logger.debug "posting line=#{line.inspect}"
			logger.debug "products_done ->" + products_done.inspect
			if !products_done.include?(line.product_id)
				products_done << line.product_id
				logger.debug "its product has not been posted yet"
				if line.product.serialized
					serials_here = line.product.get_serials_here(self.vendor_id)
					logger.debug "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#{serials_here.length.to_s}"
					old_qty = serials_here.length
					# Get a complete list of the lines in the order for this product
					product_lines = []
					for l in self.lines
						# Check if serial number is blank
						product_lines << l if l.product_id == line.product_id
					end
					logger.debug "product_lines=#{product_lines.inspect}" 
					# Add new serials
					for l in product_lines
						logger.debug "l=#{l.inspect}"
						
#						logger.debug "l.serialized_product.new_record?=#{l.serialized_product.new_record?.to_s}"
						old_loc = l.serialized_product.location
#						logger.debug "old_loc=#{old_loc.inspect}"
						if old_loc # make sure it has a location, might have just been created
							logger.debug "old_loc exists"
							logger.debug "self.vendor_id=#{self.vendor_id.to_s}"
							logger.debug "old_loc.id=#{old_loc.id.to_s}"
							if old_loc.id != self.vendor_id # It was not already here
								logger.debug "old_loc.id != self.vendor_id"
								if old_loc.entity_type== 3 # It was in a different site
									logger.debug "old_loc.entity_type== 3"
									# Make a movement to take it out of the other site
									Movement.create(:created_at=>date,:entity_id => old_loc.id, :comments => self.comments, :product_id => l.product_id, :quantity => -1, :movement_type_id => 4, :user_id => User.current_user.id,:order_id => self.id, :line_id => l.id, :serialized_product_id => l.serialized_product.id)
									i=l.product.inventories.find_by_entity_id(old_loc.id)
									i.quantity=i.quantity-1
									i.save
								end
								logger.debug "Make a movement to bring it here"
								# Make a movement to bring it here
								Movement.create(:created_at=>date,:entity_id => self.vendor_id, :comments => self.comments, :product_id => l.product_id, :quantity => 1, :movement_type_id => 4, :user_id => User.current_user.id,:order_id => self.id, :line_id => l.id, :serialized_product_id => l.serialized_product.id)
								i = l.product.inventories.find_by_entity_id(self.vendor_id)
								logger.debug "===============> old i=#{i.inspect}"
								i.quantity=i.quantity+1
								logger.debug "===============> new i=#{i.inspect}"
								i.save
							end
						else	# This serial was just created
							logger.debug "# This serial was just created"
								# Make a movement to put it here
								Movement.create(:created_at=>date,:entity_id => self.vendor_id, :comments => self.comments, :product_id => l.product_id, :quantity => 1, :movement_type_id => 4, :user_id => User.current_user.id,:order_id => self.id, :line_id => l.id, :serialized_product_id => l.serialized_product.id)
								i = l.product.inventories.find_by_entity_id(self.vendor_id)
								logger.debug "===============> old i=#{i.inspect}"
								i.quantity=i.quantity+1
								logger.debug "===============> new i=#{i.inspect}"
								i.save
						end
					end
					#Remove missing serials
					logger.debug "Remove missing serials"
					serials=[]
					for l in product_lines
						serials << l.serialized_product
					end
#					logger.debug "serials=#{serials.inspect}"
					for s in line.product.get_serials_here(self.vendor_id)
						logger.debug "s=#{s.inspect}"
						if !serials.include?(s)
							logger.debug "!serials.include?(s.id)"
							# Make a movement to remove it from here
							Movement.create(:created_at=>date,:entity_id => self.vendor_id, :comments => self.comments, :product_id => s.product_id, :quantity => -1, :movement_type_id => 4, :user_id => User.current_user.id,:order_id => self.id, :line_id => l.id, :serialized_product_id => s.id)
							i = s.product.inventories.find_by_entity_id(self.vendor_id)
							i.quantity=i.quantity-1
							i.save
							# Make movement to move it to Internal Consumption
							Movement.create(:created_at=>date,:entity_id => 1, :comments => self.comments, :product_id => s.product_id, :quantity => 1, :movement_type_id => 4, :user_id => User.current_user.id,:order_id => self.id, :line_id => l.id, :serialized_product_id => s.id)
						end
					end
					price_per = l.product.cost * (serials_here.length - old_qty) 
	        for l in product_lines
	        	logger.debug "old_qty = "+old_qty.to_s
	          l.previous_qty = old_qty
	          l.price = price_per
	        end
					logger.debug "value of serial inventory adjustment"
	        logger.debug "product_lines.length=#{product_lines.length.to_s}"
	        logger.debug "old_qty=#{old_qty.to_s}"
	        accounting_diff=(product_lines.length-old_qty) * line.product.cost
				else
					line.previous_qty = line.product.quantity
					logger.debug("previous qty = " + line.product.quantity.to_s)
        	line.price = (line.product.cost||0) * ((line.quantity||0) - (line.product.quantity||0))
					if line.quantity != line.product.quantity
						m=Movement.create(:created_at=>date,:entity_id => self.vendor_id, :comments => self.comments, :product_id => line.product_id, :quantity => line.quantity - line.product.quantity, :movement_type_id => 4, :user_id => User.current_user.id,:order_id => self.id, :line_id => line.id)
						i=line.product.inventories.find_by_entity_id(self.vendor_id)
						i.quantity=line.quantity
						products_done << line.product_id
						i.save
#						line.product.cost=line.product.calculate_cost
						products_done << line.product_id
					end
					logger.debug "value of non serial inventory adjustment"
					logger.debug "line.quantity=#{line.quantity.to_s}"
					logger.debug "line.previous_qty=#{line.previous_qty.to_s}"
	        accounting_diff=((line.quantity||0) - line.previous_qty) * line.product.cost
				end
				
				# Do Accounting
				if accounting_diff != 0
					inventory = Trans.new(:order_id=>self.id, :user=>User.current_user,:created_at=>date, :tipo=> 'Cuenta Fisica')
					inventory.posts << Post.new(:account => self.vendor.inventory_account,:created_at=>date, :value=>accounting_diff, :post_type_id =>pos_neg(accounting_diff))
					inventory.posts << Post.new(:account => self.vendor.expense_account,:created_at=>date, :value=>accounting_diff, :post_type_id => -pos_neg(accounting_diff))
					inventory.save
				end
			end
			line.received=Time.now
		end
		save_related(lines, true)
	end
#	###################################################################################
#	# Returns a list of lines from the specified count that are for the specified product_id
#	###################################################################################
#  def lines_for_product(product_id)
#    aplicable_lines=[]
#    for l in self.lines
#      if l.product_id == product_id
#      	aplicable_lines << l
#      end
#    end
#    return aplicable_lines
#  end

	###################################################################################
	# returns the date the last product to be received was received or nil if any lines are pending
	###################################################################################
	def last_received
		### ###puts "Checking for order number "+self.id.to_s
		@received=nil
		for line in self.lines do
			return nil if line.received == nil
			if @received == nil
				@received=line.received
				### ###puts line.product.name + " was received " + line.received.to_s + " 2received set to "+@received.to_s
			else 
				if line.received > @received
					### ###puts line.product.name + " was received " + line.received.to_s + " received is already "+@received.to_s
					@received=line.received
					### ###puts line.product.name + " was received " + line.received.to_s + " 1received set to "+@received.to_s
				end
			end
		end
		return @received
	end
	def void=(num)
	  self.deleted=num
	end
	def void
	  return true if deleted
	  return false
	end
	def self.sql_update(s)
		sql=ActiveRecord::Base.connection();
		sql.update(s);
	end
	def self.batch_purchase
		self.sql_update('UPDATE orders set last_batch=0 where last_batch=1;')
  	orders=[]
  	@vendors = Entity.find_all_by_entity_type_id(1)
  	for v in @vendors
  		order_made=false
  		for p in Product.find_all_by_vendor_id(v.id)
  			if p.to_order > 0
  				if !order_made
  					o=Order.new(:vendor=>v, :client=>User.current_user.location, :user=>User.current_user, :last_batch=>true, :order_type_id => 2, :created_at=>User.current_user.today)
  					order_made=true
  					orders << o
  				end	
  				if p.serialized
  					for i in (1..p.to_order)
							o.lines << o.lines.new(:product=>p, :quantity=>1,:price=>p.price,:order_type_id=>2)
						end
  				else
						o.lines << o.lines.new(:product=>p, :quantity=>p.to_order,:price=>p.price,:order_type_id=>2)
  				end
  			end
  		end
  		logger.debug "Saving order"
  		o.save if o
  	end
  	self.sql_update('UPDATE inventories set to_order=0 where to_order>0;')
  	return orders
	end
	###################################################################################
	# result of a search
	###################################################################################
	def self.search(search, order_type=nil, from=User.current_user.today, till=User.current_user.today, page=nil)
	  till=till + 1
	  still=till.to_s(:db)
	  sfrom=from.to_s(:db)
	  case order_type
	  when SALE
	    logger.debug "searching sales"
	    c= ['(order_type_id = 1) AND (clients.name like :search OR orders.receipt_number like :search) AND (vendor_id=:current_location OR clients.id=:current_location) AND (clients.id != 1) AND orders.created_at<:till AND orders.created_at>=:from', {:search => "%#{search}%", :from => "#{sfrom}",:till => "#{still}", :current_location => "#{User.current_user.location_id}"}]
	    j= "inner join entities as clients on clients.id = orders.client_id"
	  when PURCHASE
	    logger.debug "searching PURCHASE"
	    c=['((vendors.name like :search OR orders.receipt_number like :search) AND order_type_id = 2 and clients.entity_type_id = 3) AND (vendors.id=:current_location OR clients.id=:current_location)', {:search => "%#{search}%", :current_location => "#{User.current_user.location_id}"}]
	    j="inner join entities as vendors on vendors.id = orders.vendor_id inner join entities as clients on clients.id = orders.client_id"
	  when INTERNAL
	    logger.debug "searching INTERNAL"
	    c=['(vendors.name like :search OR orders.receipt_number like :search) AND orders.client_id = 1 AND orders.vendor_id=:current_location', {:search => "%#{search}%", :current_location => "#{User.current_user.location_id}"}]
	    j="inner join entities as vendors on vendors.id = orders.vendor_id"
	  when COUNT
	    logger.debug "searching COUNT"
	    c=['(location.id=:current_location) AND (orders.order_type_id = 5)', {:search => "%#{search}%", :current_location => "#{User.current_user.location_id}"}]
	    j="inner join entities as location on location.id = orders.vendor_id"
	  else
	    logger.debug "searching all according to rights"
  		search=search||''
		  c = "vendors.name like '%" + search + "%' OR clients.name like '%" + search + "%' OR orders.id like '%" + search + "%') AND (vendors.id=" + User.current_user.location_id.to_s + " OR clients.id =" + User.current_user.location_id.to_s
		  c += ' AND order_type_id != 2' if !User.current_user.has_rights(['admin','gerente','compras'])
		  c += ' AND order_type_id != 1' if !User.current_user.has_rights(['admin','gerente','ventas'])
		  c += ' AND order_type_id != 3' if !User.current_user.has_rights(['admin','gerente','compras','ventas'])
		  j="inner join entities as vendors on vendors.id = orders.vendor_id inner join entities as clients on clients.id = orders.client_id"
    end
    if page
		  paginate :per_page => 20, :page => page, :conditions => c, :order => 'created_at desc', :joins => j
		else
		  find :all, :conditions =>c, :joins => j, :order=> 'created_at desc'
		end
	end
	
	def recent_payments(limit)
		return payments(:limit=>limit, :order=>'created_at DESC')
	end
	###################################################################################
	# returns result of a search taking into consideration the current user's rights'
	###################################################################################
	def self.search_by_rights(search, page)
		search=search||''
		conditions = "vendors.name like '%" + search + "%' OR clients.name like '%" + search + "%' OR orders.receipt_number like '%" + search + "%' OR orders.id like '%" + search + "%') AND (vendors.id=" + User.current_user.location_id.to_s + " OR clients.id =" + User.current_user.location_id.to_s
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
						 :conditions => ['(order_type_id = 1) AND (vendors.name like :search OR receipt_number like :search) AND (vendor_id=:current_location OR clients.id=:current_location) AND (clients.id != 1)', {:search => "%#{search}%", :current_location => "#{User.current_user.location_id}"}],
						 :order => 'created_at desc',
						 :joins => "inner join entities as clients on clients.id = orders.client_id"
	end
#	def self.search_todays_sales(search, page)
#		paginate :per_page => 20, :page => page,
#						 :conditions => ['(order_type_id = 1) AND (clients.name like :search OR purchase_receipt_number like :search) AND (vendors.id=:current_location OR clients.id=:current_location) AND (clients.id != 1) AND (date(orders.created_at)=curdate())', {:search => "%#{search}%", :current_location => "#{User.current_user.location_id}"}],
#						 :order => 'orders.created_at desc',
#						 :joins => "inner join entities as vendors on vendors.id = orders.vendor_id inner join entities as clients on clients.id = orders.client_id"
#	end
	def self.search_purchases(search, page)
		paginate :per_page => 20, :page => page,
						 :conditions => ['((vendors.name like :search OR receipt_number like :search) AND order_type_id = 2 and clients.entity_type_id = 3) AND (vendors.id=:current_location OR clients.id=:current_location)', {:search => "%#{search}%", :current_location => "#{User.current_user.location_id}"}],
						 :order => 'created_at desc',
						 :joins => "inner join entities as vendors on vendors.id = orders.vendor_id inner join entities as clients on clients.id = orders.client_id"
	end
	def self.search_internal(search, page)
		paginate :per_page => 20, :page => page,
						 :conditions => ['(vendors.name like :search OR receipt_number like :search) AND orders.client_id = 1 AND orders.vendor_id=:current_location', {:search => "%#{search}%", :current_location => "#{User.current_user.location_id}"}],
						 :order => 'created_at desc',
						 :joins => "inner join entities as vendors on vendors.id = orders.vendor_id"
	end
	def self.search_physical_counts(search, page)
		paginate :per_page => 20, :page => page,
						 :conditions => ['(location.id=:current_location) AND (orders.order_type_id = 5)', {:search => "%#{search}%", :current_location => "#{User.current_user.location_id}"}],
						 :order => 'created_at desc',
						 :joins => "inner join entities as location on location.id = orders.vendor_id"
	end
	def self.search_purchase_batch(search, page)
		paginate :per_page => 20, :page => page,
						 :conditions => ['(last_batch=True) AND (orders.order_type_id=2) AND (vendors.name like :search OR clients.name like :search OR orders.id like :search) AND (vendors.id=:current_location OR clients.id=:current_location)', {:search => "%#{search}%", :current_location => "#{User.current_user.location_id}"}],
						 :order => 'created_at desc',
						 :joins => "inner join entities as vendors on vendors.id = orders.vendor_id inner join entities as clients on clients.id = orders.client_id"
	end
	def self.search_receipt_batch(search, page)
		paginate :per_page => 20, :page => page,
						 :conditions => ['(last_batch=True) AND (orders.order_type_id=1)AND(vendors.name like :search OR clients.name like :search OR orders.id like :search) AND (vendors.id=:current_location OR clients.id=:current_location)', {:search => "%#{search}%", :current_location => "#{User.current_user.location_id}"}],
						 :order => 'created_at desc',
						 :joins => "inner join entities as vendors on vendors.id = orders.vendor_id inner join entities as clients on clients.id = orders.client_id"
	end
	def self.search_unpaid(search, page)
  	paginate :per_page => 20, :page => page,
 						 :conditions => ['(amount_paid < grand_total) AND (order_type_id = 1) AND (clients.name like :search) AND (vendors.id=:current_location OR clients.id=:current_location) AND (clients.id != 1)', {:search => "%#{search}%", :current_location => "#{User.current_user.location_id}"}],
		         :order => 'created_at',
						 :joins => "inner join entities as vendors on vendors.id = orders.vendor_id inner join entities as clients on clients.id = orders.client_id"
	end
end
