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

##################################################################################################
# A note on uses of account fields with different entity types
#################################################################################################
# Most field names are named for their uses with a site
# Client:
#			Cash_account is the clients main account this is a receiveable(Debit) account
#   		Use it for charging a client and recording his payments
# 		Revenue account is the account that will record the amount of revenue earned from the client
# 			This should be a Revenue(Credit) account
# Vendor:
#			Cash_account is the Vendor main account this is a payable(credit) account
#   		Use it for creating an order and recording our payments
#			Revenue account is the account that will record the amount of revenue earned from this vendors products
#   		This should be a Revenue(Credit) account
#
#
#
#
#
class Entity < ActiveRecord::Base
	validates_presence_of(:name, :message => "Debe introducir el nombre de la entidad.")
  #validates_uniqueness_of(:name, :message => "El nombre de entidad ya existe.") 
  
  belongs_to :state
  
  # These are all of the price groups that are available at this site.
  # For use with Sites
  has_many :price_groups
  
  # This is the default price Group Name to use for this client
  # For use with Clients
  belongs_to :price_group_name
  
  # This is the default price group to be used if a clients normal price group isn't available here
  # to be used with Sites
  belongs_to :price_group
  
  # This is the product(service) that a certain employee offers the firm
  # To be used with Employees
  belongs_to :product


  belongs_to :site, :class_name => "Entity", :foreign_key => "site_id"
    
  belongs_to :user
  
	has_many :orders, :order => 'created_at'
	belongs_to :site, :class_name => "Entity", :foreign_key => "site_id"
	has_many :products, :through => :inventories
	has_many :products, :through => :movements
	has_many :receipts, :through => :orders, :foreign_key => "client_id"

	
	has_many :movements, :dependent => :destroy, :order => 'created_at'
	belongs_to :cash_account, :class_name => "Account", :foreign_key => "cash_account_id"
	belongs_to :inventory_account, :class_name => "Account", :foreign_key => "inventory_account_id"
	belongs_to :revenue_account, :class_name => "Account", :foreign_key => "revenue_account_id"
	belongs_to :tax_account, :class_name => "Account", :foreign_key => "tax_account_id"
	belongs_to :expense_account, :class_name => "Account", :foreign_key => "expense_account_id"
	validates_associated :movements
	after_update :save_movements
  after_create :save_movements
	
	belongs_to :entity_type
	validates_presence_of(:entity_type, :message => "Debe seleccionar el tipo de entidad.")
    
  def new_movement_attributes=(movement_attributes)
    movement_attributes.each do |attributes|
      movements.build(attributes)
    end
  end
  def unpaid_orders
  	Order.find(:all, :conditions=> 'deleted=false AND (amount_paid < grand_total OR amount_paid is null) AND (client_id=' + self.id.to_s + ')')
  end
  def unpaid_receipts
  	Receipt.find(:all, 
  							 :conditions=> 'deleted=false AND (amount_paid < grand_total OR amount_paid is null) AND (client_id=' + self.id.to_s + ')',
  							 :joins => 'inner join orders on orders.id=receipts.order_id')
  end
############################################################################################
# DEPRECATED - DEPRECATED - DEPRECATED - DEPRECATED - DEPRECATED - DEPRECATED - DEPRECATED #
############################################################################################
#	def process_subscriptions
#		#################################################################################################
#		# If the client has subscriptions to be processed, will create an order with a line for each.
#		#################################################################################################
#		# figure out the cutoff date
#		###puts "creating order for " + self.name
#  	cutoff_date=Date.today+1
#  	cutoff_date=cutoff_date+1 if Date.today.wday==6
#    # this hash will have a list of subs for each vendor
#	  subscriptions = {}
#		###puts "making a list of vendors involved"
#		###puts "1"
#		list=Subscription.find(:all, :conditions=>'(subscriptions.end_date > CURRENT_DATE OR subscriptions.end_date is null) AND (subscriptions.end_times>0 OR subscriptions.end_times is null) AND (subscriptions.client_id=' + self.id.to_s + ')' )
#		###puts "list.length " + list.length.to_s
#		###puts "2"
#		for sub in list
#	  	###puts "Here"
#		###puts "3"
#	  	# check if this sub needs to be processed
#	    if sub.last_line
#        if sub.last_line.received.to_date >> sub.frequency <= cutoff_date
#		###puts "4"
#        	###puts sub.name+" will be added - last received:" + sub.last_line.received.to_date.to_s(:long) + " cuttoff:" + cutoff_date.to_s(:long)
#        	# add the vendor if its not already in the list
#          subscriptions[sub.vendor_id] = [] if !subscriptions[sub.vendor_id]
#          # add the sub to the list
#          subscriptions[sub.vendor_id] << sub
#        else
#        	###puts (sub.name||"") + " will not be added - last received:" + (sub.last_line.received.to_date.to_s(:long)||"") + " cuttoff:" + (cutoff_date.to_s(:long)||"")
#					###puts "5"
#					###puts "sub.last_line="+sub.last_line.received.to_s
#					###puts cutoff_date.to_s
#        end
#      else  # this sub has never been processed, lets do it now
##      	###puts sub.name+" will be added cause its never been done"
##				###puts "6"
#        subscriptions[sub.vendor_id] = [] if !subscriptions[sub.vendor_id]
#        subscriptions[sub.vendor_id] << sub
#      end
# 	  	# Now we got a nice list grouped by vendor, lets make the subs
#  	  for vendor_id, list in subscriptions
##  	  	###puts "making an order for vendor: "+list[0].vendor.name
#			  o=Order.create(:vendor => list[0].vendor, :client => list[0].client,:user => User.current_user, :order_type_id => 1, :last_batch =>true)
#			  received=nil
#			  total=0
#			  for sub in list
##  	  		###puts "adding a line for: "+sub.name
#			  	new_line = sub.process(o)
#			  	received=new_line.received if !received
#			  	received=new_line.received if new_line.received > received
#			  	total += new_line.total_price_with_tax
#			  	##puts "new_line.total_price_with_tax"+new_line.total_price_with_tax.to_s
#			  	##puts "new_line.price*new_line.quantity="+(new_line.price*new_line.quantity).to_s
#		    end
#		    ##puts "total=" + total.to_s
#		    o=Order.find(o.id)
#		    o.received=received
#		    o.grand_total=total
#		    ##puts "o.grand_total=" + o.grand_total.to_s
#		    o.save
#		    o=Order.find(o.id)
#		    ##puts "o.grand_total=" + o.grand_total.to_s
#		    # now for the accounting
##		    o=Order.find(o.id)
#				sale = Trans.create(:order => o, :comments => o.comments)
##				###puts "VENDOR:" + o.total_price.to_s
#				vendor = Post.create(:trans=>sale, :account => o.vendor.revenue_account, :value=>o.total_price, :post_type_id =>Post::CREDIT)
##				###puts "CLIENT:" + o.total_price_with_tax.to_s
#				client = Post.create(:trans=>sale, :account => o.client.cash_account, :value=>o.total_price_with_tax, :post_type_id =>Post::DEBIT)
##				###puts "TAX:" + o.total_tax.to_s
#				tax    = Post.create(:trans=>sale, :account => o.vendor.tax_account, :value=>o.total_tax, :post_type_id =>Post::CREDIT)
#				inventory_cost = o.inventory_value
#				# if the sub included inventory items, we have to make that transaction also...
#				if inventory_cost > 0 
#					itrans = Trans.create(:order => o, :comments => o.comments)
#					inventory = Post.create(:trans=>itrans, :account => o.vendor.inventory_account, :value=>o.inventory_cost, :post_type_id =>2, :balance => (o.vendor.inventory_account.balance||0) - (o.inventory_cost||0))
#					expense = Post.create(:trans=>itrans, :account => o.vendor.expense_account, :value=>o.inventory_cost, :post_type_id =>1, :balance => (o.vendor.expense_account.balance||0) + (o.inventory_cost||0))
#				end
#		  end
#  	end
#	end

#  def price_group(location_id = User.current_user.location_id)
#  	location = Entity.find(location_id)
#  	pg = location.price_groups.find_by_name_id(self.default_price_group_id)
#  	if !pg
#  		pg = location.price_groups.find_by_name_id(self.price_group_name_id)
#  	end
#  	return pg
#  end
  def strip(s, c)
   clean=''
   s.each_char do |l|
		 if !c.include?(l)
		 	clean << l
		 end
   end
   return clean; 
  end
  def existing_movement_attributes=(movement_attributes)
    movements.reject(&:new_record?).each do |movement|
      attributes = movement_attributes[movement.id.to_s]
      if attributes
        movement.attributes = attributes
      else
        movements.delete(movement)
      end
    end
  end
  def products_to_order
  	products_to_order = 0
  	condition='vendor_id=' + id.to_s
  	for p in Product.find(:all, :conditions => condition)
  		if p.to_order(4) > 0
  			products_to_order += 1
  		end
  	end
  	return products_to_order
  end
  def save_movements
    movements.each do |movement|
      movement.save(false)
    end
  end
  def home_phone_number
  	if self.home_phone
			if self.home_phone.length == 8
				return self.home_phone[0..3] + "-" + self.home_phone[4..7]
			end
		end
  end
  def home_phone_number=(number)
  	self.home_phone=strip(number, ['-',' '])
  end
  def office_phone_number
  	if self.office_phone
			if self.office_phone.length == 8
				return self.office_phone[0..3] + "-" + self.office_phone[4..7]
			end
		end
  end
  def office_phone_number=(number)
  	self.office_phone=strip(number, ['-',' '])
  end
  def cell_phone_number
	  if self.cell_phone
			if self.cell_phone.length == 8
				return self.cell_phone[0..3] + "-" + self.cell_phone[4..7]
			end
		end
  end
  def cell_phone_number=(number)
  	self.cell_phone=strip(number, ['-',' '])
  end
  def nit_number
  	if self.nit
			if self.nit.length == 14
				return self.nit[0..3] + "-" + self.nit[4..9] + "-" + self.nit[10..12] + "-" + self.nit[13].to_s
			end
		end
  end
  def nit_number=(number)
  	self.nit=strip(number, ['-',' '])
  end
  def compile_condition(search)
  	search = search || ""
  	logger.debug "search="+ search
  	
  	condition="("
  	fields_to_search=[]
  	join=""
  	search_words=[]
  	words = search.downcase.split( / *"(.*?)" *| / ) 
  	for word in words
  		if word[0..5]=='activo'
  			condition += ' AND entities.active=TRUE' if word[6..word.length+1] == ':si'
  			condition += ' AND entities.active=FALSE' if word[6..word.length+1] == ':no'  		
  		elsif word[0..3]=='tipo'
  			if word[4..word.length+1] == ':cliente' or word[4..word.length+1] == ':clients' or word[4..word.length+1] == ':clientes'
  				fields_to_search << "entities.name"
  				fields_to_search << "client_group.name"
  				fields_to_search << "entities.id"
  				fields_to_search << "users.login"
  				fields_to_search << "entities.oldid"
  				condition += " AND (entities.site_id = " + User.current_user.location_id.to_s + " or entities.id=3 or entities.id=4) AND (entity_type_id = 2 OR entity_type_id = 5)"
  			elsif word[4..word.length+1] == ':credito' or word[4..word.length+1] == ':wholesale_clients'
  				fields_to_search << "entities.name"
  				fields_to_search << "client_group.name"
  				fields_to_search << "entities.id"
  				fields_to_search << "users.login"
  				condition += " AND (entities.site_id = " + User.current_user.location_id.to_s + " or entities.id=3 or entities.id=4) AND entity_type_id = 5"
  			elsif word[4..word.length+1] == ':consumidor' or word[4..word.length+1] == ':end_users'
  				fields_to_search << "entities.name"
  				fields_to_search << "client_group.name"
  				fields_to_search << "entities.id"
  				fields_to_search << "users.login"
  				fields_to_search << "entities.oldid"
  				condition += " AND (entities.site_id = " + User.current_user.location_id.to_s + " or entities.id=3 or entities.id=4) AND entity_type_id = 2"
  			elsif word[4..word.length+1] == ':proveedor' or word[4..word.length+1] == ':vendors' or word[4..word.length+1] == ':proveedores'
  				fields_to_search << "entities.name"
  				fields_to_search << "entities.id"
  				fields_to_search << "users.login"
  				condition += " AND entity_type_id = 1"
  			elsif word[4..word.length+1] == ':sitio' or word[4..word.length+1] == ':site'
  				fields_to_search << "entities.name"
  				fields_to_search << "site_group.name"
  				fields_to_search << "entities.id"
  				condition += " AND entity_type_id = 3"
  			end
  		elsif word[0..6]=='asesor:'
  			condition += ' AND entities.user_id=' + (word[7..word.length+1]||0).to_s
  		elsif word[0..3]=='dia:'
  			condition += ' AND entities.active = TRUE AND entities.subscription_day = ' + (word[4..word.length+1]||0).to_s
  		else
  			search_words << word
  		end
  	end
 	
  	#add in actual searching of fields
  	condition += " AND ("
  	for word in search_words
  		condition+= " AND ("
  		for field in fields_to_search
  			condition+= " OR " + field + " like '%" + word + "%'"
  		end
  		condition += ")"
  	end
  	condition += "))"
  	logger.debug "condition1="+condition
   	# remove all '( AND's and '( OR's
#   	condition = condition[5..condition.length+1]
   	condition =condition.gsub("( AND ", "(")
  	logger.debug "condition2="+condition
   	condition =condition.gsub("( OR ", "(")
  	logger.debug "condition3="+condition
#   	condition =condition.gsub("( AND )", " ")
  	logger.debug "condition4="+condition
#   	condition =condition.gsub("( OR )", "")
  	logger.debug "condition5="+condition
   	condition =condition.gsub("()", "")
  	logger.debug "condition6="+condition
   	condition =condition.gsub("()", "")
#   	condition =condition.gsub("( AND )", " ")
  	logger.debug "condition7="+condition
   	condition =condition.gsub("()", "")
#   	condition =condition.gsub("( OR )", "")
  	logger.debug "condition8="+condition
   	condition =condition.gsub("AND )", ")")
  	logger.debug "condition9="+condition
   	condition="" if condition == " AND "
  	logger.debug "condition10="+condition
  	return condition
  end
  def self.search(search, page)
  	search = search || ""
  	logger.debug "search="+ search
  	
  	condition="("
  	fields_to_search=[]
  	join=""
  	search_words=[]
  	words = search.downcase.split( / *"(.*?)" *| / ) 
  	for word in words
  		if word[0..5]=='activo'
  			condition += ' AND entities.active=TRUE' if word[6..word.length+1] == ':si'
  			condition += ' AND entities.active=FALSE' if word[6..word.length+1] == ':no'  		
  		elsif word[0..3]=='tipo'
  			if word[4..word.length+1] == ':cliente' or word[4..word.length+1] == ':clients' or word[4..word.length+1] == ':clientes'
  				fields_to_search << "entities.name"
  				fields_to_search << "client_group.name"
  				fields_to_search << "entities.id"
  				fields_to_search << "entities.oldid"
  				fields_to_search << "users.login"
  				condition += " AND (entities.site_id = " + User.current_user.location_id.to_s + " or entities.id=3 or entities.id=4) AND (entity_type_id = 2 OR entity_type_id = 5)"
  			elsif word[4..word.length+1] == ':credito' or word[4..word.length+1] == ':wholesale_clients'
  				fields_to_search << "entities.name"
  				fields_to_search << "client_group.name"
  				fields_to_search << "entities.id"
  				fields_to_search << "entities.oldid"
  				fields_to_search << "users.login"
  				condition += " AND (entities.site_id = " + User.current_user.location_id.to_s + " or entities.id=3 or entities.id=4) AND entity_type_id = 5"
  			elsif word[4..word.length+1] == ':consumidor' or word[4..word.length+1] == ':end_users'
  				fields_to_search << "entities.name"
  				fields_to_search << "client_group.name"
  				fields_to_search << "entities.id"
  				fields_to_search << "entities.oldid"
  				fields_to_search << "users.login"
  				condition += " AND (entities.site_id = " + User.current_user.location_id.to_s + " or entities.id=3 or entities.id=4) AND entity_type_id = 2"
  			elsif word[4..word.length+1] == ':proveedor' or word[4..word.length+1] == ':vendors' or word[4..word.length+1] == ':proveedores'
  				fields_to_search << "entities.name"
  				fields_to_search << "entities.id"
  				fields_to_search << "entities.oldid"
  				fields_to_search << "users.login"
  				condition += " AND entity_type_id = 1"
  			elsif word[4..word.length+1] == ':sitio' or word[4..word.length+1] == ':site'
  				fields_to_search << "entities.name"
  				fields_to_search << "site_group.name"
  				fields_to_search << "entities.id"
  				condition += " AND entity_type_id = 3"
  			end
  		elsif word[0..6]=='asesor:'
  			condition += ' AND entities.user_id=' + word[7..word.length+1].to_s if word[7..word.length+1].to_s != ""
  		elsif word[0..3]=='dia:'
  			condition += ' AND entities.active=TRUE AND entities.subscription_day=' + word[4..word.length+1].to_s if word[4..word.length+1].to_s != ""
  		elsif word[0..2]=='id:'
  			condition += ' AND entities.id=' + word[3..word.length+1].to_s
  		else
  			search_words << word
  		end
  	end
 	
  	#add in actual searching of fields
  	condition += " AND ("
  	for word in search_words
  		condition+= " AND ("
  		for field in fields_to_search
  			condition+= " OR " + field + " like '%" + word + "%'"
  		end
  		condition += ")"
  	end
  	condition += "))"
  	logger.debug "condition1="+condition
   	# remove all '( AND's and '( OR's
#   	condition = condition[5..condition.length+1]
   	condition =condition.gsub("( AND ", "(")
  	logger.debug "condition2="+condition
   	condition =condition.gsub("( OR ", "(")
  	logger.debug "condition3="+condition
#   	condition =condition.gsub("( AND )", " ")
  	logger.debug "condition4="+condition
#   	condition =condition.gsub("( OR )", "")
  	logger.debug "condition5="+condition
   	condition =condition.gsub("()", "")
  	logger.debug "condition6="+condition
   	condition =condition.gsub("()", "")
#   	condition =condition.gsub("( AND )", " ")
  	logger.debug "condition7="+condition
   	condition =condition.gsub("()", "")
#   	condition =condition.gsub("( OR )", "")
  	logger.debug "condition8="+condition
   	condition =condition.gsub("AND )", ")")
  	logger.debug "condition9="+condition
   	condition="" if condition == " AND "
  	logger.debug "condition10="+condition
   	paginate :per_page => 20, :page => page,
		       :conditions => condition,
		       :joins => 'left join price_group_names as client_group on client_group.id=entities.price_group_name_id left join price_groups on entities.price_group_id=price_groups.id left join price_group_names as site_group on site_group.id = price_groups.price_group_name_id left join users on users.id=entities.user_id',
		       :order => 'name'
  end
  def self.search_without_pagination(search)
  	search = search || ""
  	logger.debug "search="+ search
  	
  	condition="("
  	fields_to_search=[]
  	join=""
  	search_words=[]
  	words = search.downcase.split( / *"(.*?)" *| / ) 
  	for word in words
  		if word[0..5]=='activo'
  			condition += ' AND entities.active=TRUE' if word[6..word.length+1] == ':si'
  			condition += ' AND entities.active=FALSE' if word[6..word.length+1] == ':no'  		
  		elsif word[0..3]=='tipo'
  			if word[4..word.length+1] == ':cliente' or word[4..word.length+1] == ':clients' or word[4..word.length+1] == ':clientes'
  				fields_to_search << "entities.name"
  				fields_to_search << "client_group.name"
  				fields_to_search << "entities.id"
  				fields_to_search << "users.login"
  				condition += " AND (entities.site_id = " + User.current_user.location_id.to_s + " or entities.id=3 or entities.id=4) AND (entity_type_id = 2 OR entity_type_id = 5)"
  			elsif word[4..word.length+1] == ':credito' or word[4..word.length+1] == ':wholesale_clients'
  				fields_to_search << "entities.name"
  				fields_to_search << "client_group.name"
  				fields_to_search << "entities.id"
  				fields_to_search << "users.login"
  				condition += " AND (entities.site_id = " + User.current_user.location_id.to_s + " or entities.id=3 or entities.id=4) AND entity_type_id = 5"
  			elsif word[4..word.length+1] == ':consumidor' or word[4..word.length+1] == ':end_users'
  				fields_to_search << "entities.name"
  				fields_to_search << "client_group.name"
  				fields_to_search << "entities.id"
  				fields_to_search << "users.login"
  				condition += " AND (entities.site_id = " + User.current_user.location_id.to_s + " or entities.id=3 or entities.id=4) AND entity_type_id = 2"
  			elsif word[4..word.length+1] == ':proveedor' or word[4..word.length+1] == ':vendors' or word[4..word.length+1] == ':proveedores'
  				fields_to_search << "entities.name"
  				fields_to_search << "entities.id"
  				fields_to_search << "users.login"
  				condition += " AND entity_type_id = 1"
  			elsif word[4..word.length+1] == ':sitio' or word[4..word.length+1] == ':site'
  				fields_to_search << "entities.name"
  				fields_to_search << "site_group.name"
  				fields_to_search << "entities.id"
  				condition += " AND entity_type_id = 3"
  			end
  		elsif word[0..6]=='asesor:'
  			condition += ' AND entities.user_id=' + word[7..word.length+1].to_s if word[7..word.length+1].to_s != ""
  		elsif word[0..3]=='dia:'
  			condition += ' AND entities.active=TRUE AND entities.subscription_day=' + word[4..word.length+1].to_s if word[4..word.length+1].to_s != ""
  		elsif word[0..2]=='id:'
  			condition += ' AND entities.id=' + word[3..word.length+1].to_s
  		else
  			search_words << word
  		end
  	end
 	
  	#add in actual searching of fields
  	condition += " AND ("
  	for word in search_words
  		condition+= " AND ("
  		for field in fields_to_search
  			condition+= " OR " + field + " like '%" + word + "%'"
  		end
  		condition += ")"
  	end
  	condition += "))"
  	logger.debug "condition1="+condition
   	# remove all '( AND's and '( OR's
#   	condition = condition[5..condition.length+1]
   	condition =condition.gsub("( AND ", "(")
  	logger.debug "condition2="+condition
   	condition =condition.gsub("( OR ", "(")
  	logger.debug "condition3="+condition
#   	condition =condition.gsub("( AND )", " ")
  	logger.debug "condition4="+condition
#   	condition =condition.gsub("( OR )", "")
  	logger.debug "condition5="+condition
   	condition =condition.gsub("()", "")
  	logger.debug "condition6="+condition
   	condition =condition.gsub("()", "")
#   	condition =condition.gsub("( AND )", " ")
  	logger.debug "condition7="+condition
   	condition =condition.gsub("()", "")
#   	condition =condition.gsub("( OR )", "")
  	logger.debug "condition8="+condition
   	condition =condition.gsub("AND )", ")")
  	logger.debug "condition9="+condition
   	condition="" if condition == " AND "
  	logger.debug "condition10="+condition
   	find 	 :all,
		       :conditions => condition,
		       :joins => 'left join price_group_names as client_group on client_group.id=entities.price_group_name_id left join price_groups on entities.price_group_id=price_groups.id left join price_group_names as site_group on site_group.id = price_groups.price_group_name_id left join users on users.id=entities.user_id',
		       :order => 'name'
  end
############################################################################################
# DEPRECATED - DEPRECATED - DEPRECATED - DEPRECATED - DEPRECATED - DEPRECATED - DEPRECATED #
############################################################################################
#  def self.search(search, page, entity_type='all', user_id=nil, sub_day=nil)
#  	####puts "search=" + search
#  	search = search || ""
#  	if search[0..6]=='activos'
#  		active=1
#  		search=[7..search.length]
#  	elsif search[0..8]=='inactivos'
#  		active=0
#  		search=[9..search.length]
#  	end
#  	####puts "search=" + search
#  	case entity_type
#			when 'clients'
#				condition = "(entities.name like '%" + search +"%' OR client_group.name like '%" + search +"%' OR entities.id like '%" + search +"%' OR users.login like '%" + search +"%') AND (entity_type_id = 2 OR entity_type_id = 5)"
#			when 'end_users'
#				condition = "(entities.name like '%" + search +"%' OR client_group.name like '%" + search +"%' OR entities.id like '%" + search +"%' OR users.login like '%" + search +"%') AND entity_type_id = 2"
#			when 'wholesale_clients'
#				condition = "(entities.name like '%" + search +"%' OR client_group.name like '%" + search +"%' OR entities.id like '%" + search +"%' OR users.login like '%" + search +"%') AND entity_type_id = 5"
#			when 'vendors'
#				condition = "(entities.name like '%" + search +"%' OR entities.id like '%" + search +"%' OR users.login like '%" + search +"%') AND entity_type_id = 1"
#			when 'sites'
#				condition = "(entities.name like '%" + search +"%' OR site_group.name like '%" + search +"%' OR entities.id like '%" + search +"%') AND entity_type_id = 3"
#			else
#				condition = "(entities.name like '%" + search +"%' OR client_group.name like '%" + search +"%' OR site_group.name like '%" + search +"%' OR entities.id like '%" + search +"%' OR users.login like '%" + search +"%') AND entities.id!=1"
#  	end
#  	if active==1
#  		condition += ' AND entities.active = TRUE'
#  	elsif active==0
#  		condition += ' AND entities.active = FALSE'
#  	elsif active==3
#  		condition += ' AND entities.retired = TRUE'
#  	end
#  	condition += ' AND entities.subscription_day = ' + sub_day.to_s if sub_day
#  	condition += ' AND entities.user_id = ' + user_id.to_s if user_id
#  	if entity_type=='clients' or entity_type=='end_users' or entity_type=='wholesale_clients'
#  	    # only show for this site, but always include anonimo and no spcificado
#      	condition += ' AND (entities.site_id = ' + User.current_user.location_id.to_s + ' or entities.id=3 or entities.id=4) ' 
#    end
#  	####puts "condition=" + condition
#		paginate :per_page => 20, :page => page,
#		       :conditions => condition,
#		       :joins => 'left join price_group_names as client_group on client_group.id=entities.price_group_name_id left join price_groups on entities.price_group_id=price_groups.id left join price_group_names as site_group on site_group.id = price_groups.price_group_name_id left join users on users.id=entities.user_id',
#		       :order => 'name'
#	end
	def self.find_all_clients
	  condition = "(entity_type_id = 2 OR entity_type_id = 5)"
  	condition += ' AND entities.site_id = ' + User.current_user.location_id.to_s
		find :all, :conditions => condition, :order => 'name'
	end
	def self.search_clients_without_pagination(search, sub_day=nil)
		condition = "(entities.name like '%" + search + "%' OR client_group.name like '%" + search + "%' OR entities.id like '%" + search + "%' OR users.login like '%" + search + "%') AND (entity_type_id=2 OR entity_type_id = 5)"
  	condition += ' AND entities.subscription_day = ' + sub_day.to_s if sub_day
  	condition += ' AND entities.site_id = ' + User.current_user.location_id.to_s
		find :all, :conditions => condition, :order => 'name'
	end
	def self.search_birthdays(search)
		search = search || ""
  	list = find :all,
		         		:conditions => "entities.name like '%" + search + "%' AND (entity_type_id = 2 OR entity_type_id = 5)",
		        		:order => 'name'
		list.delete_if {|x| !x.birthday? }
		return list
	end
	def birthday?
		logger.debug "self.birth=#{self.birth.inspect}"
		if self.birth
			if self.birth.strftime("%j") == Time.now.strftime("%j")
				return true
			else
				return false
			end
		else
			return false
		end		
	end
	def inventory(product)
		###puts "product.id=" + product.id.to_s
		###puts "self.id=" + self.id.to_s
		if product.inventories.find_by_entity_id(self.id)
			return product.inventories.find_by_entity_id(self.id).quantity
		else
			return 0
		end
	end
end
