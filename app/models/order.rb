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
	has_many :receipts
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
  	## ##puts "validating order"
  end
	after_update :save_lines
	after_create :create_lines
	after_update :check_for_discounts
	after_create :check_for_discounts
	after_update :create_transactions
	after_create :create_transactions
	after_create :create_movements
  after_update :create_movements
  before_save :update_grand_total
	belongs_to :vendor, :class_name => "Entity", :foreign_key => 'vendor_id'
	belongs_to :client, :class_name => "Entity", :foreign_key => 'client_id'
	validates_presence_of(:vendor, :message => "debe ser valido")
	validates_presence_of(:client, :message => "debe ser valido")
	#validates_associated :lines
	belongs_to :user
	validates_presence_of(:user, :message => "debe ser valido")
	############################## End of Creating Movements ####################################
	attr_accessor :movements_to_create
	attr_accessor :transactions_to_create # list of trans to create
	##################################################################################################
	# 
	#################################################################################################
	def	update_grand_total
    self.grand_total = self.total_price_with_tax
  end
  ##################################################################################################
  # 
  #################################################################################################
	def create_transactions
		##puts "credit = " + Account::CREDIT.to_s
	  ##puts "create transactions -> @transactions_to_create = "+@transactions_to_create.to_s
	  @transactions_to_create = [] if !@transactions_to_create
	  for t in @transactions_to_create
	  	if t
				t.order_id=self.id
				t.save
			end
	  end
	end
	##################################################################################################
	# 
	#################################################################################################
	def create_receipts
	  # Prepare the data           ------------------------------------------------
	  @data=[]
	  total=0
	  for l in self.lines
		  x = Object.new.extend(ActionView::Helpers::NumberHelper)
		  if l.product.serialized
			  if l.serialized_product
				  @data << [l.quantity.to_s, l.product.name + " - " + l.serialized_product.serial_number, x.number_to_currency(l.price), "", x.number_to_currency(l.total_price)]
			  end
		  else
			  @data << [l.quantity.to_s, l.product.name, x.number_to_currency(l.price), "", x.number_to_currency(l.total_price)]
		  end
		  total += l.total_price
		end  
	  # Call the appropriate format ------------------------------------------------
	  
	  if self.client.entity_type.id == 2
	    consumidor_final # from the formats.rb file
	  else
	    credito_fiscal # from the formats.rb file
	  end
	  r=Receipt.create(:created_at=>User.current_user.today,:order=>params[:order_id], :number =>params[:number], :filename=>"#{RAILS_ROOT}/invoice_pdfs/order #{self.id}.pdf")
	  return r
	end
	##################################################################################################
	# 
	#################################################################################################
	def cash_account
		for pref in Preference.find(:all, :order=>'value', :conditions=>"pref_group='cash'")
			case pref.id
			when 7 #Site
				logger.debug " Grabbing revenue account from Site"
				if self.vendor
					return self.vendor.cash_account if self.vendor.cash_account
				end
			when 8 #Current User
				logger.debug " Grabbing revenue account from Current User"
				return User.current_user.cash_account if User.current_user.cash_account
			when 9 #Clients Rep
				logger.debug " Grabbing revenue account from Clients Rep"
				if self.client
					if self.client.user
						return self.client.user.cash_account if self.client.user.cash_account
					end
				end
			end
		end
		# If there are no other valid options, use the sites revenue account
		##puts "vendor:" + self.vendor_id.to_s
		##puts "Couldnt find any other valid accounts, so we're using the vendors account:" + self.vendor.cash_account_id
		return self.vendor.cash_account
	end
	##################################################################################################
	# This function is to complement markreceived so we can set the received date on an order and its 
	# lines but have the widget stay null by default
	#################################################################################################
	def markreceived=(fecha)
		puts "fecha:" + fecha.to_s
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
	# Returns a revision of a transaction with the Credit and Debit Posts Reversed
	#################################################################################################
	def reverse_transaction(t)
		for p in t.posts
			if p.post_type_id==Post::DEBIT
				p.post_type_id=Post::CREDIT
			else
				p.post_type_id=Post::DEBIT
			end
		end
		return t
	end
	##################################################################################################
	# Marks order as null and does appropriate transactions in accounting.
	#################################################################################################
	def anull
	  #you can't null an order if we received money for it.
		return false if self.amount_paid != 0 
		main=main_transaction
		main.order=self
		reverse_transaction(main).save()
		i=inventory_transaction
		if i
			i.order=self
			reverse_transaction(inventory_transaction).save()
		end
		self.deleted=1
		for line in self.lines
        line.isreceived_str = "No"
    end
    for receipt in self.receipts
        receipt.deleted=User.current_user.today
        receipt.save
    end
		return self.save()
	end
	##################################################################################################
	# This function is to complement markreceived so we can set the received date on an order and its 
	# lines but have the widget stay null by default
	#################################################################################################
	def markreceived
		return nil
	end
	##################################################################################################
	# 
	#################################################################################################
	def create_movements
		@movements_to_create = [] if !@movements_to_create
		#collect the values of each movement type
		values={}
		for m in @movements_to_create
		  if !values[m.movement_type_id]
		    values[m.movement_type_id] = m.value 
		  else
		    values[m.movement_type_id] += m.value
		  end
		end
		
		for m in @movements_to_create
			# Save movement from the list
#			m.line_id=self.id
      m.order_id=self.id
			m.save
			qty=m.quantity || 0

			p=Product.find(m.product_id)
			if p.product_type_id==1
				i=p.inventories.find_by_entity_id(m.entity_id)
				if i # Don't worry about it if they dont have a i, its probably a client
					i.quantity=i.quantity + m.quantity
					i.save
				end
			end
			# Update costs
#			p.cost=p.calculate_cost  <---- This has been moved to order.after_create_lines and order.after_update_lines
    # This has been moved back cause order.create_lines and order.save_lines served no purpose since the lines were already being saved
            p.update_cost

		end
		# Erase list
		@movements_to_create.clear
	end
	##################################################################################################
	# 
	#################################################################################################
	def quantity_change_direction(new, old)
		logger.debug "Checking movement direction"
		if new.received and !old.received 		# The line was marked received
			logger.debug "The line was marked received"
			return 1
		elsif old.received and !new.received	# The line was unmarked received
			logger.debug "The line was unmarked received"
			return -1 
		elsif old.received and new.received		# The line was always received
			logger.debug "The line was always received"
			if new.quantity > old.quantity			# The quantity increased
				return 1
			elsif new.quantity < old.quantity		# The quantity decreased
				return -1
			end
		end
		logger.debug "The line was never received"
		return 0
	end
	##################################################################################################
	# 
	#################################################################################################
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
	##################################################################################################
	# 
	#################################################################################################
	def movement_type_id(direction)
		case order_type_id
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
  ###################################################################################
  # prepares a single movement to be created but DOES NOT SAVE IT
  ##################################################################################
	def create_movement_for(line, entity_id, movement_type_id, quantity)
	  value = (line.price||0) * (line.quantity||0)
		m=Movement.new(:created_at=>User.current_user.today,:entity_id => entity_id, :comments => self.comments, :product_id => line.product_id, :quantity => quantity, :movement_type_id => movement_type_id, :user_id => User.current_user.id,:order_id => self.id, :serialized_product_id => line.serialized_product_id, :value => value)
		@movements_to_create = [] if !@movements_to_create 
		@movements_to_create.push(m)
	end
	def main_transaction
		puts "Creating main transaction"
		case order_type_id
		when 1 #Venta
			sale=Trans.new(:user=>User.current_user,:created_at=>User.current_user.today)
      sale.posts << Post.new(:account => self.client.cash_account, :value=>self.total_price_with_tax, :post_type_id =>Post::DEBIT)
      if self.total_tax != 0
      	##puts "=======================adding tax self.total_tax="+self.total_tax.to_s
      	sale.posts << Post.new(:account => self.vendor.tax_account, :value=>self.total_tax, :post_type_id =>Post::CREDIT)
      end
      revenue_accts={}
      for line in self.lines
      	r=line.revenue_account(self).id
      	if revenue_accts[r]
      		revenue_accts[r] += line.total_price
      	else
      		revenue_accts[r] = line.total_price
      	end
      end
      revenue_accts.each { |key, value| 
      	acct= Account.find(key)
				sale.posts << Post.new(:account => acct, :value=>value, :post_type_id =>Post::CREDIT)
			}    
			return sale   
		when 2 # Compra
	    ##puts self.vendor.cash_account.to_s
	    ##puts self.total_price_with_tax.to_s
	    purchase = Trans.new(:user=>User.current_user,:created_at=>User.current_user.today)
	    purchase.posts << Post.new(:account => self.vendor.cash_account, :value => self.total_price_with_tax, :post_type_id =>Post::CREDIT)
      purchase.posts << Post.new(:account => self.client.inventory_account, :value => self.total_price_with_tax, :post_type_id =>Post::DEBIT)
			return purchase
    end
	end
	def inventory_transaction
		inventory_cost = self.inventory_value
    if inventory_cost > 0
    	inventory = Trans.new(:user=>User.current_user,:created_at=>User.current_user.today)
	    inventory.posts << Post.new(:account => self.vendor.inventory_account, :value=>inventory_cost, :post_type_id =>Post::CREDIT)
	    inventory.posts << Post.new(:account => self.vendor.expense_account, :value=>inventory_cost, :post_type_id =>Post::DEBIT)
	  end
	  return inventory
	end
  ###################################################################################
  # compares two transactions and subtracts the second from the first
  ##################################################################################
	def transaction_diff(old, newtrans)
		accounts_done=[]
		diff=Trans.new(:user=>User.current_user,:created_at=>User.current_user.today)
		if old and !newtrans
#			##puts "newtrans is null"
			for oldpost in old.posts
				diff.posts << Post.new(:account =>oldpost.account, :value=> oldpost.value, :post_type_id=>oldpost.opposite_type)
			end
		elsif newtrans and !old
#			##puts "old trans is null"
			for newpost in newtrans.posts
				diff.posts << newpost
			end
		elsif newtrans and old
#			##puts "we have both trans"
			for oldpost in old.posts
				#find the matching post
#			##puts "newtrans has the following posts" + newtrans.posts.inspect
#			##puts "newtrans.posts.find_by_account_id(5)" + newtrans.posts.find_by_post_type_id(1).to_s

				newpost = newtrans.post_by_account_id(oldpost.account_id)
#				##puts "old post.account_id="+ oldpost.account_id.to_s
#				##puts "newpost.inspect="+ newpost.inspect
				if newpost
					if oldpost.value > newpost.value
#						##puts "Difference in values " + oldpost.value.to_s + "-" + newtrans.value.to_s + "=" + (oldpost.value-newtrans.value).to_s
						diff.posts << Post.new(:account =>oldpost.account, :value=> oldpost.value-newpost.value, :post_type_id=>oldpost.opposite_type)
					elsif oldpost.value < newpost.value
						diff.posts << Post.new(:account =>oldpost.account, :value=> newpost.value-oldpost.value, :post_type_id=>oldpost.post_type_id)					
					end
				else
#					##puts "missing new post for account#" + oldpost.account.id.to_s
					diff.posts << Post.new(:account =>oldpost.account, :value=> oldpost.value, :post_type_id=>oldpost.opposite_type)
				end
				accounts_done << oldpost.account_id
			end
			for newpost in newtrans.posts
				if !accounts_done.include?(newpost.account_id)
					diff.posts << newpost
				end			
			end
		end
		return nil if diff.posts.length==0
		return diff
	end
  ###################################################################################
  # checks if there are any transactions to be made, if so, it calls prepare_transaction
  ##################################################################################
	def check_for_transactions
		if User.current_user.do_accounting
			if self.new_record?
			  @transactions_to_create = [main_transaction, inventory_transaction]
			else
				##puts "Checking for transactions in this update"
				##puts "current total price: " + self.total_price.to_s
				##puts "current total price: " + self.total_price.to_s
			  old = Order.find(self.id)
				##puts "old.total_price" + old.total_price.to_s
			  if self.total_price != old.total_price or self.total_tax != old.total_tax
			  	##puts "yup, we gotta make a transaction for this one"
			  	##puts "old main transaction" + old.main_transaction.posts.inspect
			  	##puts "new main transaction" + self.main_transaction.posts.inspect
			  	##puts "dif main transaction" + transaction_diff(old.main_transaction, self.main_transaction).posts.inspect
			  	@transactions_to_create = [transaction_diff(old.main_transaction, self.main_transaction)]
			  	##puts "old inventory transaction" + old.inventory_transaction.posts.inspect if old.inventory_transaction
			  	##puts "new inventory transaction" + self.inventory_transaction.posts.inspect if self.inventory_transaction
	#	    	##puts "dif inventory transaction" + transaction_diff(old.inventory_transaction, self.inventory_transaction).posts.inspect
			  	i=transaction_diff(old.inventory_transaction, self.inventory_transaction)
			  	@transactions_to_create << i if i
			  end
			end	
		end
	end
  ###################################################################################
  # prepares the movements to be created but DOES NOT SAVE THEM
  ##################################################################################
	def prepare_movements(line)
	  logger.debug "==============line.product.product_type_id=#{line.product.inspect}"
	  if line.product.product_type_id == 1
		  old = Line.find_by_id(line.id)
		  ##puts old.inspect
		  if old
			  dir = quantity_change_direction(line, old)
		  else
			  if line.received
				  dir = 1
			  else
				  dir = 0
			  end
		  end
#			##puts "----------------->" + dir.to_s
		  if dir != 0
			  case movement_type_id(dir)
				  when 1
					  create_movement_for(line, self.vendor_id, 1, -quantity_change(line, old))
					  create_movement_for(line, self.client_id, 1, quantity_change(line, old))
				  when 2
					  create_movement_for(line, self.client_id, 2, quantity_change(line, old))
				  when 3
					  create_movement_for(line, self.client_id, 3, quantity_change(line, old))
					  create_movement_for(line, self.vendor_id, 3, -quantity_change(line, old))
				  # We won't touch physical counts. The Physical Count model will take care of that.
				  when 5
					  create_movement_for(line, self.vendor_id, 5, -quantity_change(line, old))
				  when 6
					  create_movement_for(line, self.client_id, 6, quantity_change(line, old))
				  when 7
					  create_movement_for(line, self.client_id, 7, quantity_change(line, old))
					  create_movement_for(line, self.vendor_id, 7, -quantity_change(line, old))
				  when 8
					  create_movement_for(line, self.vendor_id, 8, -quantity_change(line, old))
				  when 9
					  create_movement_for(line, self.vendor_id, 9, -quantity_change(line, old))
			  end
		  end
	  end
	end
  ###################################################################################
  # creates new lines and fills them with the contents specified. DOES NOT SAVE THEM
  ##################################################################################
	def create_all_lines(lines)
	  lines=[] if !lines
  	for l in lines
  		new_line = Line.new(:order_type_id=>self.order_type_id, :order_id=>self.id,:created_at=>User.current_user.today)
  		#new_line.product_name = l[:product_name]  		
  		new_line.product_id = l[:product_id]  	
			new_line.quantity = l[:quantity]  
			#new_line.set_serial_number_with_product(l[:serial_number], l[:product_name])
  		#logger.debug "product id:   ->" + l[:product_name]
  		logger.debug "new_line.warranty.to_s before=" + new_line.warranty.to_s.to_s
  		puts "new line type " + new_line.order_type_id.inspect
  		new_line.attributes = l
  		logger.debug "new_line.warranty.to_s= after" + new_line.warranty.to_s.to_s
  		self.lines << new_line
  		prepare_movements(new_line)
  		check_for_transactions
  	end
	end
  ###################################################################################
  # updates existing lines on the order, adds new ones and deletes missing ones. DOES NOT SAVE THEM
  ##################################################################################
	def update_all_lines(new_lines=[], existing_lines=[])
	  ##puts "Lines before updating" + self.lines.length.to_s
		lines_changed_for_accounting = []
		##puts "====================UPDATEING ALL LINES===================="
		lines_to_delete=[]
    #Update existing lines
    if existing_lines
		  for l in self.lines
				if existing_lines[l.id.to_s]
					if l.quantity != existing_lines[l.id.to_s][:quantity] or l.price != existing_lines[l.id.to_s][:price]
						lines_changed_for_accounting << l
					end
					l.attributes = existing_lines[l.id.to_s]
				else # We really shouldn't delete these lines yet, but leave them marked so they get deleted when the model is saved
					lines_changed_for_accounting << l
					lines_to_delete << l
				end
			end
			for l in lines_to_delete
				self.lines.delete(l)
			end
		else
			self.lines.clear
		end
		new_lines=[] if !new_lines
	  ##puts "Lines before updating new ones" + Order.find(self.id).lines.length.to_s
		# Update New lines
  	for l in new_lines
  		new_line = Line.new(:order_id=>self.id,:created_at=>User.current_user.today)
  		new_line.product_id = l[:product_id]		
  		new_line.quantity = l[:quantity]
	  ##puts "Lines before setting attributes" + Order.find(self.id).lines.length.to_s
  		new_line.attributes=l  
#  		logger.debug "about to push #{new_line.inspect}"  	
	  ##puts "Lines before pushing new lines" + Order.find(self.id).lines.length.to_s
  		self.lines << new_line
  	end
	  ##puts "Lines before preparing movements" + Order.find(self.id).lines.length.to_s
  	for l in self.lines
  		prepare_movements(l)
  	end
	  ##puts "Lines before checking for transactions" + Order.find(self.id).lines.length.to_s
	  total=new_lines.inject(0) { |s,l| s += l[:quantity].to_i*l[:price].to_i }
#	  total = existing_lines.inject(total) { |s,l| s += l[:quantity]*l[:price] }
		if existing_lines
			for s, l in existing_lines
				total += l["quantity"].to_i * l["price"].to_i
			end
		end
	  check_for_transactions	
	end
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
  def get_sum(product)
  	sum=0
  	o=Order.find(self.id)
  	## ##puts "num lines: " + o.lines.count.to_s
  	for line in o.lines
  		## ##puts "checking line#" + line.id.to_s
  		if line.product.id==product.id
  			## ##puts "found some"
  			sum+=line.quantity
  		end
  	end
  	return sum
  end
  
  ###################################################################################
	# Returns total quantity of an item contained in this order
	###################################################################################
  def inventory_value
  	sum=0
  	## ##puts "num lines: " + o.lines.count.to_s
  	for line in self.lines
  		## ##puts "checking line#" + line.id.to_s
  		if line.product.product_type_id==1
  			## ##puts "found some"
  			sum+=line.product.cost*line.quantity
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
		  # ##puts "@wehave ->" + @wehave.to_s + "<-"
		  # ##puts "@weneed ->" + @weneed.to_s + "<-"
		  @temp = @wehave / @weneed
		
		  # ##puts "@temp ->" + @temp.to_s + "<-"
		  # ##puts "@qualify ->" + @qualify.to_s + "<-"
		  @qualify= [@qualify, @temp].min
		  # ##puts "@qualify ->" + @qualify.to_s + "<-"
	  end #req in discount.requirements
	  return nil if @qualify == 10000
    return @qualify
  end
	
  ###################################################################################
	# Checks if the order qualifies for any discounts and adds lines for them as necisary
	###################################################################################
  def check_for_discounts
  	puts "checking existing discounts <============================================================================="
  	# Go through each discount in the order and see if it still qualifys
  	# ##puts "self.order_type_id"+(self.order_type_id==1).to_s
  	if self.order_type_id==1
			@discounts_in_order= []
			for line in self.lines.find(:all, 
																	:conditions => ' products.product_type_id = 2 ',
																	:joins => ' inner join products on lines.product_id=products.id ')
#	  		puts "checking " + line.product.name
				@discounts_in_order << line.product
				@qualify = discount_qualifies(line.product)
				if @qualify > 0
					# Set the quantity of this discount to the number of times we qualify
					line.quantity = @qualify
					line.save()
				else
					# Remove discount since we no longer qualify
					# ##puts line.id.to_s
					self.lines.delete(line)
				end
			end
			# Go through each discount and see if the order qualifies
			puts "checking new discounts"
			for discount in get_discounts do 
				puts "checking" + discount.name
				#make sure we dont add a discount thats already in the order
				if !@discounts_in_order.include?(discount)
					# make sure the discount is available in this site
					if discount.available
						puts discount.name + "available" 
						@qualify = self.discount_qualifies(discount)
						#If the order qualifies, add it.
						if @qualify >= 1			                     		
							puts "It Qualifies!!!!!!!!!!!!!!!!!!!"
							l=Line.new(:order_id => self.id, :product_id => discount.id, :quantity => @qualify, :price => discount.price, :received => 1,:created_at=>User.current_user.today)
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
	# 
	#################################################################################################
	def pay_off()
	  if grand_total > amount_paid
  	  Payment.create(:order=>self, :amount=>grand_total-amount_paid, :payment_method_id=>1, :user=>User.current_user, :receipt=>self.receipts.first, :presented=>grand_total-amount_paid, :created_at=>User.current_user.today)
    end
	end
############################################################################################
# DEPRECATED - DEPRECATED - DEPRECATED - DEPRECATED - DEPRECATED - DEPRECATED - DEPRECATED #
############################################################################################
#	###################################################################################
#	# Returns the total of all the payments made for this order
#	###################################################################################
#	def amount_paid
#		return self.payments.sum(:presented)-self.payments.sum(:returned)
#	end
	
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
									Movement.create(:entity_id => old_loc.id, :comments => self.comments, :product_id => l.product_id, :quantity => -1, :movement_type_id => 4, :user_id => User.current_user.id,:order_id => self.id, :line_id => l.id, :serialized_product_id => l.serialized_product.id,:created_at=>User.current_user.today)
									i=l.product.inventories.find_by_entity_id(old_loc.id)
									i.quantity=i.quantity-1
									i.save
								end
								logger.debug "Make a movement to bring it here"
								# Make a movement to bring it here
								Movement.create(:entity_id => self.vendor_id, :comments => self.comments, :product_id => l.product_id, :quantity => 1, :movement_type_id => 4, :user_id => User.current_user.id,:order_id => self.id, :line_id => l.id, :serialized_product_id => l.serialized_product.id,:created_at=>User.current_user.today)
								i = l.product.inventories.find_by_entity_id(self.vendor_id)
								logger.debug "===============> old i=#{i.inspect}"
								i.quantity=i.quantity+1
								logger.debug "===============> new i=#{i.inspect}"
								i.save
							end
						else	# This serial was just created
							logger.debug "# This serial was just created"
								# Make a movement to put it here
								Movement.create(:created_at=>User.current_user.today,:entity_id => self.vendor_id, :comments => self.comments, :product_id => l.product_id, :quantity => 1, :movement_type_id => 4, :user_id => User.current_user.id,:order_id => self.id, :line_id => l.id, :serialized_product_id => l.serialized_product.id)
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
							Movement.create(:created_at=>User.current_user.today,:entity_id => self.vendor_id, :comments => self.comments, :product_id => s.product_id, :quantity => -1, :movement_type_id => 4, :user_id => User.current_user.id,:order_id => self.id, :line_id => l.id, :serialized_product_id => s.id)
							i = s.product.inventories.find_by_entity_id(self.vendor_id)
							i.quantity=i.quantity-1
							i.save
							# Make movement to move it to Internal Consumption
							Movement.create(:created_at=>User.current_user.today,:entity_id => 1, :comments => self.comments, :product_id => s.product_id, :quantity => 1, :movement_type_id => 4, :user_id => User.current_user.id,:order_id => self.id, :line_id => l.id, :serialized_product_id => s.id)
						end
					end
					price_per = l.product.cost * (serials_here.length - old_qty) 
	        for l in product_lines
	        	logger.debug "old_qty = "+old_qty.to_s
	          l.previous_qty = old_qty
	          l.price = price_per
	        end
				else
					line.previous_qty = line.product.quantity
					logger.debug("previous qty = " + line.product.quantity.to_s)
        	line.price = (line.product.cost||0) * ((line.quantity||0) - (line.product.quantity||0))
					if line.quantity != line.product.quantity
						m=Movement.create(:created_at=>User.current_user.today,:entity_id => self.vendor_id, :comments => self.comments, :product_id => line.product_id, :quantity => line.quantity - line.product.quantity, :movement_type_id => 4, :user_id => User.current_user.id,:order_id => self.id, :line_id => line.id)
						i=line.product.inventories.find_by_entity_id(self.vendor_id)
						i.quantity=line.quantity
						products_done << line.product_id
						i.save
						line.product.cost=line.product.calculate_cost
						products_done << line.product_id
					end
				end
			end
			line.received=Time.now
		end
	end
	###################################################################################
	# Returns the a list of lines from the specified count that are for the specified product_id
	###################################################################################
  def lines_for_product(product_id)
    aplicable_lines=[]
    for l in self.lines
      if l.product_id == product_id
      	aplicable_lines << l
      end
    end
    return aplicable_lines
  end
	###################################################################################
	# saves all lines in the order are returns true if successful
	###################################################################################
	def save_lines
		sucessful = true
		 ##puts "saving lines"
		logger.debug "saving lines"
		lines.each do |line|
			sucessful = false if !line.save(false)
			##puts "saving a line"
#			logger.debug "new cost:" + p.cost().to_s
		end
		return sucessful
	end
	
	# NOTE: Many times when a new line is created, save_lines gets run instead of create_lines
	###################################################################################
	# creates a new line for this order
	###################################################################################
	def create_lines
		 ##puts "creating lines"
		sucessful = true
		# ##puts lines.inspect
		self.lines.each do |line|
			##puts "setting order_id to " + self.id.to_s
			##puts "creating a line"
			line.order_id = self.id 
			sucessful = false if !line.save(true)
		end		
		# ##puts "end"
		return sucessful
	end
	###################################################################################
	# returns the date the last product to be received was received or nil if any lines are pending
	###################################################################################
	def last_received
		### ##puts "Checking for order number "+self.id.to_s
		@received=nil
		for line in self.lines do
			return nil if line.received == nil
			if @received == nil
				@received=line.received
				### ##puts line.product.name + " was received " + line.received.to_s + " 2received set to "+@received.to_s
			else 
				if line.received > @received
					### ##puts line.product.name + " was received " + line.received.to_s + " received is already "+@received.to_s
					@received=line.received
					### ##puts line.product.name + " was received " + line.received.to_s + " 1received set to "+@received.to_s
				end
			end
		end
		return @received
	end
	
	###################################################################################
	# result of a search
	###################################################################################
	def self.search(search, page)
		paginate :per_page => 20, :page => page,
						 :conditions => ['(vendors.name like :search OR clients.name like :search OR orders.id like :search) AND (vendors.id=:current_location OR clients.id=:current_location)', {:search => "%#{search}%", :current_location => "#{User.current_user.location_id}"}],
						 :order => 'created_at desc',
						 :joins => "inner join entities as vendors on vendors.id = orders.vendor_id inner join entities as clients on clients.id = orders.client_id"
	end
	
	def recent_payments(limit)
		return payments(:limit=>limit, :order=>'created_at DESC')
	end
	###################################################################################
	# returns result of a search taking into consideration the current user's rights'
	###################################################################################
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
						 :conditions => ['(order_type_id = 1) AND (clients.name like :search) AND (vendors.id=:current_location OR clients.id=:current_location) AND (clients.id != 1)', {:search => "%#{search}%", :current_location => "#{User.current_user.location_id}"}],
						 :order => 'created_at desc',
						 :joins => "inner join entities as vendors on vendors.id = orders.vendor_id inner join entities as clients on clients.id = orders.client_id"
	end
	def self.search_todays_sales(search, page)
		paginate :per_page => 20, :page => page,
						 :conditions => ['(order_type_id = 1) AND (clients.name like :search) AND (vendors.id=:current_location OR clients.id=:current_location) AND (clients.id != 1) AND (date(orders.created_at)=curdate())', {:search => "%#{search}%", :current_location => "#{User.current_user.location_id}"}],
						 :order => 'orders.created_at desc',
						 :joins => "inner join entities as vendors on vendors.id = orders.vendor_id inner join entities as clients on clients.id = orders.client_id"
	end
	def self.search_purchases(search, page)
		paginate :per_page => 20, :page => page,
						 :conditions => ['(vendors.name like :search AND order_type_id = 2 and clients.entity_type_id = 3) AND (vendors.id=:current_location OR clients.id=:current_location)', {:search => "%#{search}%", :current_location => "#{User.current_user.location_id}"}],
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
