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
	ANONIMO=3
	ANULADO=9
  def to_param
    "#{id}-#{name.parameterize}"
  end
	##################################################################################################
	# 
	#################################################################################################
  def validate
  	#logger.debug "HERE in validate++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    errors.add "Nombre","no es válido" if !name or name==''
    if self.new_record?
    	errors.add "Nombre ","debe ser único" if Entity.find(:first,:conditions=> "name = '#{name}'")
    end
  end  
  belongs_to :state
  
  # These are all of the price groups that are available at this site.
  # For use with Sites
  has_many :price_groups
  
  # These are the default branches that entities made in this site should be under
  # For use with Sites
  has_many :default_branches
  
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
	
	belongs_to :new_individual_client_accounts_parent, :class_name => "Account", :foreign_key => "new_individual_client_accounts_parent_id"
	belongs_to :new_corporate_client_accounts_parent, :class_name => "Account", :foreign_key => "new_corporate_client_accounts_parent_id"
	belongs_to :new_vendor_accounts_parent, :class_name => "Account", :foreign_key => "new_vendor_accounts_parent_id"
	belongs_to :new_employee_accounts_parent, :class_name => "Account", :foreign_key => "new_employee_accounts_parent_id"
	belongs_to :client_accounts_group, :class_name => "Account", :foreign_key => "client_accounts_group_id"
	belongs_to :vendor_accounts_group, :class_name => "Account", :foreign_key => "vendor_accounts_group_id"
	belongs_to :employee_accounts_group, :class_name => "Account", :foreign_key => "employee_accounts_group_id"
	
	validates_associated :movements
	after_update :save_movements
  after_create :save_movements
  
  
	def cash_account_name
 	 cash_account.name if cash_account
	end
	def cash_account_name=(name)
		self.cash_account = Account.find_by_name_or_create({:name=>name, :is_parent => false, :modifier=>Post::DEBIT}) unless name.blank?
#		self.cash_account = Account.find_or_create_by_name(name) unless name.blank?
	end
	def client_account_name
 	 cash_account.name if cash_account
	end
	def client_account_name=(name)
		self.cash_account = Account.find_by_name_or_create({:name=>name, :is_parent => false, :modifier=>Post::DEBIT}) unless name.blank?
#		self.cash_account = Account.find_or_create_by_name(name) unless name.blank?
	end
	def vendor_account_name
 	 cash_account.name if cash_account
	end
	def vendor_account_name=(name)
		self.cash_account = Account.find_by_name_or_create({:name=>name, :is_parent => false, :modifier=>Post::DEBIT}) unless name.blank?
#		self.cash_account = Account.find_or_create_by_name(name) unless name.blank?
	end
	def inventory_account_name
 	 inventory_account.name if inventory_account
	end
	def inventory_account_name=(name)
		self.inventory_account = Account.find_by_name_or_create({:name=>name, :is_parent => false, :modifier=>Post::DEBIT}) unless name.blank?
#		self.inventory_account = Account.find_or_create_by_name(name) unless name.blank?
	end
	def revenue_account_name
 	 revenue_account.name if revenue_account
	end
	def revenue_account_name=(name)
		self.revenue_account = Account.find_by_name_or_create({:name=>name, :is_parent => false, :modifier=>Post::CREDIT}) unless name.blank?
#		self.revenue_account = Account.find_or_create_by_name(name) unless name.blank?
	end
	def tax_account_name
 	 tax_account.name if tax_account
	end
	def tax_account_name=(name)
		self.cash_account = Account.find_by_name_or_create({:name=>name, :is_parent => false, :modifier=>Post::CREDIT}) unless name.blank?
#		self.tax_account = Account.find_or_create_by_name(name) unless name.blank?
	end
	def expense_account_name
 	 expense_account.name if expense_account
	end
	def expense_account_name=(name)
		self.cash_account = Account.find_by_name_or_create({:name=>name, :is_parent => false, :modifier=>Post::DEBIT}) unless name.blank?
#		self.expense_account = Account.find_or_create_by_name(name) unless name.blank?
	end
	def new_individual_client_accounts_parent_name
 	 new_individual_client_accounts_parent.name if new_individual_client_accounts_parent
	end
	def new_individual_client_accounts_parent_name=(name)
		self.cash_account = Account.find_by_name_or_create({:name=>name, :is_parent => true, :modifier=>Post::DEBIT}) unless name.blank?
#		self.new_individual_client_accounts_parent = Account.find_or_create_by_name(name) unless name.blank?
	end
	def new_corporate_client_accounts_parent_name
 	 new_corporate_client_accounts_parent.name if new_corporate_client_accounts_parent
	end
	def new_corporate_client_accounts_parent_name=(name)
		self.cash_account = Account.find_by_name_or_create({:name=>name, :is_parent => true, :modifier=>Post::DEBIT}) unless name.blank?
#		self.new_corporate_client_accounts_parent = Account.find_or_create_by_name(name) unless name.blank?
	end
	def new_vendor_accounts_parent_name
 	 new_vendor_accounts_parent.name if new_vendor_accounts_parent
	end
	def new_vendor_accounts_parent_name=(name)
		self.cash_account = Account.find_by_name_or_create({:name=>name, :is_parent => true, :modifier=>Post::CREDIT}) unless name.blank?
#		self.new_vendor_accounts_parent = Account.find_or_create_by_name(name) unless name.blank?
	end
	def new_employee_accounts_parent_name
 	 new_employee_accounts_parent.name if new_employee_accounts_parent
	end
	def new_employee_accounts_parent_name=(name)
		self.cash_account = Account.find_by_name_or_create({:name=>name, :is_parent => true, :modifier=>Post::CREDIT}) unless name.blank?
#		self.new_employee_accounts_parent = Account.find_or_create_by_name(name) unless name.blank?
	end
	def client_accounts_group_name
 	 client_accounts_group.name if client_accounts_group
	end
	def client_accounts_group_name=(name)
		self.cash_account = Account.find_by_name_or_create({:name=>name, :is_parent => true, :modifier=>Post::DEBIT}) unless name.blank?
#		self.client_accounts_group = Account.find_or_create_by_name(name) unless name.blank?
	end
	def vendor_accounts_group_name
 	 vendor_accounts_group.name if vendor_accounts_group
	end
	def vendor_accounts_group_name=(name)
		self.cash_account = Account.find_by_name_or_create({:name=>name, :is_parent => true, :modifier=>Post::CREDIT}) unless name.blank?
#		self.vendor_accounts_group = Account.find_or_create_by_name(name) unless name.blank?
	end
	def employee_accounts_group_name
 	 employee_accounts_group.name if employee_accounts_group
	end
	def employee_accounts_group_name=(name)
		self.cash_account = Account.find_by_name_or_create({:name=>name, :is_parent => true, :modifier=>Post::CREDIT}) unless name.blank?
#		self.employee_accounts_group = Account.find_or_create_by_name(name) unless name.blank?
	end
	
  before_update :update_account_name
	def update_account_name
		if self.entity_type_id!=3 and self.cash_account
			if self.name!= self.cash_account.name
				self.cash_account.name = self.name
				self.cash_account.save
			end
		end
	end
	
	belongs_to :entity_type  
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
	def recent_entries
		return Entry.find(:all, :conditions=> "accounts.entity_id=#{self.id}",:joins=>'inner join accounts on entries.account_id=accounts.id', :order=>'created_at DESC', :limit=>20)
	end
  def strip(s, c)
   clean=''
   s.each_char do |l|
		 if !c.include?(l)
		 	clean << l
		 end
   end
   return clean; 
  end
  def birth_string
    return birth.to_s
  end
  def birth_string=(val)
    birth=DateTime.strptime(val, '%d/%m/%Y %H:%M:%S')
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
  def create_account(prefix, suffix, parent_id)
		account_name = (prefix||'') + self.name + (suffix||'')
		puts "account_name=#{account_name.to_s}"
		puts "parent_id=#{parent_id.to_s}"
		puts "Account.find(parent_id).name=#{Account.find(parent_id).name.to_s}"
		puts "Account.find(parent_id).modifier=#{Account.find(parent_id).modifier.to_s}"
		puts "Account.find(parent_id)=#{Account.find(parent_id).to_s}"
		parent=Account.find(parent_id)
	  mod=parent.modifier if parent
		account=Account.create(:name=> account_name, :parent_id=>parent_id, :number=>'',:modifier=>mod, :is_parent=>0)
		puts "account=#{account.to_s}"
		return account
	end
  before_create :create_accounts
	def create_accounts()
		puts "self.entity_type_id=#{self.entity_type_id.to_s}" 
		if self.entity_type_id==1
		  if self.site
    		group_id=self.site.vendor_accounts_group_id 
    	else
        group_id=User.current_user.location.vendor_accounts_group_id
      end  	
		elsif self.entity_type_id==2 or self.entity_type_id==5
		  if self.site
    		group_id=self.site.client_accounts_group_id 
    	else
        group_id=User.current_user.location.client_accounts_group_id
      end  	
    end 
		case self.entity_type_id
		when 3 #Site
			self.cash_account = create_account(NEW_SITE_CASH_ACCOUNT_PREFIX, 				NEW_SITE_CASH_ACCOUNT_SUFFIX, 			NEW_SITE_CASH_ACCOUNT_PARENT_ID) if !self.cash_account
			self.expense_account = create_account(NEW_SITE_EXPENSE_ACCOUNT_PREFIX, 		NEW_SITE_EXPENSE_ACCOUNT_SUFFIX, 		NEW_SITE_EXPENSE_ACCOUNT_PARENT_ID) if !self.expense_account
			self.revenue_account = create_account(NEW_SITE_REVENUE_ACCOUNT_PREFIX, 		NEW_SITE_REVENUE_ACCOUNT_SUFFIX, 		NEW_SITE_REVENUE_ACCOUNT_PARENT_ID) if !self.revenue_account
			self.tax_account = create_account(NEW_SITE_TAX_ACCOUNT_PREFIX, 				NEW_SITE_TAX_ACCOUNT_SUFFIX, 				NEW_SITE_TAX_ACCOUNT_PARENT_ID) if !self.tax_account
			self.inventory_account = create_account(NEW_SITE_INVENTORY_ACCOUNT_PREFIX, 	NEW_SITE_INVENTORY_ACCOUNT_SUFFIX, 	NEW_SITE_INVENTORY_ACCOUNT_PARENT_ID) if !self.inventory_account
			self.vendor_accounts_group = create_account(VENDOR_ACCOUNTS_GROUP_PREFIX, 				VENDOR_ACCOUNTS_GROUP_SUFFIX, 			VENDOR_ACCOUNTS_GROUP_PARENT_ID) if !self.vendor_accounts_group
			self.employee_accounts_group = create_account(EMPLOYEE_ACCOUNTS_GROUP_PREFIX, 			EMPLOYEE_ACCOUNTS_GROUP_SUFFIX, 		EMPLOYEE_ACCOUNTS_GROUP_PARENT_ID) if !self.employee_accounts_group
			self.client_accounts_group = create_account(CLIENT_ACCOUNTS_GROUP_PREFIX, 				CLIENT_ACCOUNTS_GROUP_SUFFIX, 			CLIENT_ACCOUNTS_GROUP_PARENT_ID) if !self.client_accounts_group
		when 2 # Client
			self.cash_account = create_account(NEW_CLIENT_ACCOUNT_PREFIX, NEW_CLIENT_ACCOUNT_SUFFIX, group_id) if !self.cash_account_id			
		when 5 # Client 
			self.cash_account = create_account(NEW_CLIENT_ACCOUNT_PREFIX, NEW_CLIENT_ACCOUNT_SUFFIX, group_id) if !self.cash_account_id			
		when 1 # Vendor
			self.cash_account = create_account(NEW_VENDOR_ACCOUNT_PREFIX, NEW_VENDOR_ACCOUNT_SUFFIX, group_id) if !self.cash_account_id			
		end
		puts "DID NOT CREATE A CASH ACCOUNT!!!! <+++++++++++++++++++++++++++++==" if !self.cash_account
	end
	after_create :update_accounts_with_my_id
  def update_accounts_with_my_id()
  	if self.entity_type_id==3
			self.cash_account.entity=self
			self.cash_account.save()
			self.expense_account.entity=self
			self.expense_account.save()
			self.revenue_account.entity=self
			self.revenue_account.save()
			self.tax_account.entity=self
			self.tax_account.save()
			self.inventory_account.entity=self
			self.inventory_account.save()
		else
			if self.cash_account
				self.cash_account.entity=self
				self.cash_account.save()
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
  def fax_number
  	if self.fax
			if self.fax.length == 8
				return self.fax[0..3] + "-" + self.fax[4..7]
			end
		end
  end
  def fax_number=(number)
  	self.fax=strip(number, ['-',' '])
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
  def full_address
  	address=''
  	if self.address
  	  address += self.address
  	end
  	if self.city
  	 	address+=", "+self.city
  	end
  	if self.state and address != ''
  	 	address += ", " + self.state.name
  	end
  	return address
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
#  				fields_to_search << "entities.oldid"
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
#  				fields_to_search << "entities.oldid"
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
#  				fields_to_search << "entities.oldid"
  				fields_to_search << "users.login"
  				condition += " AND (entities.site_id = " + User.current_user.location_id.to_s + " or entities.id=3 or entities.id=4) AND (entity_type_id = 2 OR entity_type_id = 5)"
  			elsif word[4..word.length+1] == ':credito' or word[4..word.length+1] == ':wholesale_clients'
  				fields_to_search << "entities.name"
  				fields_to_search << "client_group.name"
  				fields_to_search << "entities.id"
#  				fields_to_search << "entities.oldid"
  				fields_to_search << "users.login"
  				condition += " AND (entities.site_id = " + User.current_user.location_id.to_s + " or entities.id=3 or entities.id=4) AND entity_type_id = 5"
  			elsif word[4..word.length+1] == ':consumidor' or word[4..word.length+1] == ':end_users'
  				fields_to_search << "entities.name"
  				fields_to_search << "client_group.name"
  				fields_to_search << "entities.id"
#  				fields_to_search << "entities.oldid"
  				fields_to_search << "users.login"
  				condition += " AND (entities.site_id = " + User.current_user.location_id.to_s + " or entities.id=3 or entities.id=4) AND entity_type_id = 2"
  			elsif word[4..word.length+1] == ':proveedor' or word[4..word.length+1] == ':vendors' or word[4..word.length+1] == ':proveedores'
  				fields_to_search << "entities.name"
  				fields_to_search << "entities.id"
#  				fields_to_search << "entities.oldid"
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
