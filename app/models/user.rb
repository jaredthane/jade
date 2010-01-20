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

require 'digest/sha1'
class User < ActiveRecord::Base

	cattr_accessor :current_user

	belongs_to :location, :class_name => "Entity", :foreign_key => 'location_id'
	belongs_to :price_group_name
  # Virtual attribute for the unencrypted password
  attr_accessor :password
	has_many :movements
	has_many :orders
	belongs_to :cash_account, :class_name => "Account", :foreign_key => 'cash_account_id'
	belongs_to :revenue_account, :class_name => "Account", :foreign_key => 'revenue_account_id'
	belongs_to :personal_account, :class_name => "Account", :foreign_key => 'personal_account_id'
	has_many :roles_users
	has_many :roles, :through => :roles_users
#	has_and_belongs_to_many :roles
  validates_presence_of     :login
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  #validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :login, :case_sensitive => false
  before_save :encrypt_password
  
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :password, :password_confirmation, :do_accounting, :name, :date, :today, :roles, :roles_users, :personal_account_id, :cash_account_id, :revenue_account_id, :default_received, :location, :price_group_name
	def clients
		return Entity.find_all_by_user_id(self.id)
	end
	def today
		if self.date
			logger.debug "self.date=#{self.date.to_s}"
			logger.debug "Time.now.change(:year=>self.date.year, :month=>self.date.month, :day=>self.date.day)=#{Time.now.change(:year=>self.date.year, :month=>self.date.month, :day=>self.date.day).to_s}"
			return Time.now.change(:year=>self.date.year, :month=>self.date.month, :day=>self.date.day)
		else
			return Date.today
		end
	end
	def today=(value)
		self.date=value.to_date
	end
	def current_price_group
#		logger.debug "location_id=#{location_id.to_s}"
#		logger.debug "price_group_name=#{price_group_name.to_s}"
#		logger.debug "price_group_name.price_groups.count=#{price_group_name.price_groups.count.to_s}"
	if !self.price_group_name
		if self.location
			self.price_group_name=self.location.price_group.price_group_name
		else
			self.price_group_name=PriceGroupName.first
		end
	end
#	logger.debug "self.price_group_name=" + self.price_group_name.name
#	logger.debug "looking in location=" + self.location.name
		pg=price_group_name.price_groups.find_by_entity_id(location_id) # this selects the group indicated if available
#		logger.debug "pg=#{pg.to_s}"
#		logger.debug "Entity.find(location_id)=#{Entity.find(location_id).to_s}"
# otherwise well grab the default for this site		
		if !pg
			pg=Entity.find(location_id).price_group  
		end
		return pg
	end
	
  def self.search(search, page)
  	paginate :per_page => 20, :page => page,
		         :conditions => ['users.login like :search or roles.title like :search', {:search => "%#{search}%"}],
		         :order => 'login',
		         :joins => "left outer join roles_users on roles_users.user_id=users.id left outer join roles on roles.id = roles_users.role_id", 
		         :group => "users.id"
	end
	def sales_data(from, till)
		rep={}
		rep[:user]=self
		sql = ActiveRecord::Base.connection()
		# Checking Previous Orders
		query = "SELECT sum(grand_total) AS total, count(orders.id) AS count FROM `orders` inner join entities as clients on clients.id=orders.client_id WHERE (clients.user_id=" + self.id.to_s + " AND date(orders.created_at) <'" + from.to_date.to_s("%Y-%m-%d") + "')"
		results = sql.execute(query).fetch_hash
		rep[:previous_orders_count] = (results["count"].to_i||0)
		rep[:previous_orders_total] = (results["total"].to_f||0)
		# Checking Previous Payments
		query="SELECT count(*) as count, sum(presented-returned) AS total FROM `payments` inner join orders on orders.id=payments.order_id inner join entities as clients on clients.id=orders.client_id WHERE (clients.user_id=" + self.id.to_s + " AND date(payments.created_at) <'" + from.to_date.to_s("%Y-%m-%d") + "');"
		result = sql.execute(query).fetch_hash
		rep[:previous_payments_count] = (result["count"].to_i||0)
		rep[:previous_payments_total] = (result["total"].to_f||0)
		# Checking Current Orders (Within range specified)
		query = "SELECT sum(grand_total) AS total, count(orders.id) AS count FROM `orders` inner join entities as clients on clients.id=orders.client_id WHERE (clients.user_id=" + self.id.to_s + " AND date(orders.created_at) >='" + from.to_date.to_s("%Y-%m-%d") + "' AND date(orders.created_at) <= '" + till.to_date.to_s('%Y-%m-%d') + "')"
		result = sql.execute(query).fetch_hash
		rep[:current_orders_count] = (result["count"].to_i||0)
		rep[:current_orders_total] = (result["total"].to_f||0)
		# Checking Payments Orders (Within range specified)				
		query="SELECT count(*) as count, sum(presented-returned) AS total FROM `payments` inner join orders on orders.id=payments.order_id inner join entities as clients on clients.id=orders.client_id WHERE (clients.user_id=" + self.id.to_s + " AND date(payments.created_at) >='" + from.to_date.to_s("%Y-%m-%d") + "' AND date(payments.created_at) <= '" + till.to_date.to_s('%Y-%m-%d') + "');"
		result = sql.execute(query).fetch_hash
		rep[:current_payments_count] = (result["count"].to_i||0)
		rep[:current_payments_total] = (result["total"].to_f||0)
		return rep
	end
#	def self.sales_reps_data(from, till, site)
#		sql = ActiveRecord::Base.connection()
#		reps=[]
#		for r in User.find_all_by_location_id(site)
#			if r.clients.length>0
#				logger.debug "User:" + r.name
#				rep={:user=>r, :num_receipts=>0, :revenue=>0, :num_payments=>0, :cash_received=>0, :final_balance=>0}
#				# Checking Previous Orders
#				query = "SELECT sum(grand_total) AS total, count(orders.id) AS count FROM `orders` inner join entities as clients on clients.id=orders.client_id WHERE (clients.user_id=" + self.id.to_s + " AND date(orders.created_at) <'" + from.to_date.to_s("%Y-%m-%d") + "')"
#				results = sql.execute(query).fetch_hash
#				previous_orders_count = results["count"].to_i
#				previous_orders_total = results["total"].to_f
#				# Checking Previous Payments
#				query="SELECT count(*) as count, sum(presented-returned) AS total FROM `payments` inner join orders on orders.id=payments.order_id inner join entities as clients on clients.id=orders.client_id WHERE (clients.user_id=" + self.id.to_s + " AND date(payments.created_at) <'" + from.to_date.to_s("%Y-%m-%d") + "');"
#				result = sql.execute(query).fetch_hash
#				previous_payments_count = result["count"].to_i
#				previous_payments_total = result["total"].to_f
#				# Checking Current Orders (Within range specified)
#				query = "SELECT sum(grand_total) AS total, count(orders.id) AS count FROM `orders` inner join entities as clients on clients.id=orders.client_id WHERE (clients.user_id=" + self.id.to_s + " AND date(orders.created_at) >='" + from.to_date.to_s("%Y-%m-%d") + "' AND date(orders.created_at) <= '" + till.to_date.to_s('%Y-%m-%d') + "')"
#				result = sql.execute(query).fetch_hash
#				current_orders_count = result["count"].to_i
#				current_orders_total = result["total"].to_f
#				# Checking Payments Orders (Within range specified)				
#				query="SELECT count(*) as count, sum(presented-returned) AS total FROM `payments` inner join orders on orders.id=payments.order_id inner join entities as clients on clients.id=orders.client_id WHERE (clients.user_id=" + self.id.to_s + " AND date(payments.created_at) >='" + from.to_date.to_s("%Y-%m-%d") + "' AND date(payments.created_at) <= '" + till.to_date.to_s('%Y-%m-%d') + "');"
#				result = sql.execute(query).fetch_hash
#				current_payments_count = result["count"].to_i
#				current_payments_total = result["total"].to_f
#				
#				rep[:previous_balance] = (previous_orders_total||0) - (previous_payments_total||0)
#				rep[:num_receipts] = current_orders_count
#				rep[:revenue] = current_orders_total
#				rep[:num_payments] = current_payments_count
#				rep[:cash_received] = current_payments_total
#				rep[:facturas_pendientes] = previous_orders_count + current_orders_count - previous_payments_count - current_payments_count
#				rep[:final_balance] = rep[:previous_balance] + current_orders_total - current_payments_total
##				rep[:num_payments] = Payment.count(:all, 
##										:conditions=> ['clients.user_id=:rep_id AND date(payments.created_at) >=:from AND date(payments.created_at) <= :till', {:from=>from.to_date.to_s('%Y-%m-%d'), :till=>till.to_date.to_s('%Y-%m-%d'), :rep_id=>self.id}],
##										:joins=>'inner join orders on orders.id=payments.order_id inner join entities as clients on clients.id=orders.client_id')
##				payment_posts=Post.find(:all, 
##						:conditions=> ['date(trans.created_at) >=:from AND date(trans.created_at) <= :till AND posts.account_id=:account', {:from=>from.to_date.to_s('%Y-%m-%d'), :till=>till.to_date.to_s('%Y-%m-%d'), :account=>self.cash_account_id}],
##						:joins=>'inner join trans on trans.id=posts.trans_id')
##				if payment_posts
##					rep[:cash_received]=payment_posts.collect(&:value).sum 
##				else
##					rep[:cash_received]=0
##				end
#				
##				payments_made=Payment.count(:all,
##					:conditions=> ['clients.user_id=:rep_id AND date(payments.created_at) <= :till', {:till=>till.to_date.to_s('%Y-%m-%d'), :rep_id=>self.id}],
##					:joins=>'inner join orders on orders.id=payments.order_id inner join entities as clients on clients.id=orders.client_id')
##				orders_made=Order.count(:all,
##					:conditions=> ['clients.user_id=:rep_id AND date(orders.created_at) <= :till', {:till=>till.to_date.to_s('%Y-%m-%d'), :rep_id=>self.id}],
##					:joins=>'inner join entities as clients on clients.id=orders.client_id'
##				)
##				rep[:facturas_pendientes]=orders_made-payments_made
##				new_cash_balance, new_rev_balance, old_cash_balance, old_rev_balance=nil, nil, nil, nil
##				if r.cash_account
###					new_cash_balance=r.cash_account.balance
##					logger.debug "geting first_cash_post "
##					first_cash_post=Post.last(:conditions=> ['date(trans.created_at) < :from AND posts.account_id=:account', {:from=>from.to_date.to_s('%Y-%m-%d'), :account=>self.cash_account_id}],:joins=>'inner join trans on trans.id=posts.trans_id',:order=>'created_at')
##					old_cash_balance=first_cash_post.balance  if first_cash_post
##					
##					logger.debug "geting last_cash_post "
##					last_cash_post=Post.last(:conditions=> ['date(trans.created_at) < :till AND posts.account_id=:account', {:till=>(till.to_date+1).to_s('%Y-%m-%d'), :account=>self.cash_account_id}],:joins=>'inner join trans on trans.id=posts.trans_id',:order=>'created_at')
##					new_cash_balance=last_cash_post.balance  if last_cash_post
##				end
##				if r.revenue_account
###					new_rev_balance=r.revenue_account.balance
##					logger.debug "geting first_rev_post "
##					first_rev_post=Post.last(:conditions=> ['date(trans.created_at) < :from AND posts.account_id=:account', {:from=>from.to_date.to_s('%Y-%m-%d'), :account=>self.revenue_account_id}],:joins=>'inner join trans on trans.id=posts.trans_id',:order=>'created_at')
##					old_rev_balance=first_rev_post.balance if first_rev_post
##					logger.debug "geting last_rev_post "
##					last_rev_post=Post.last(:conditions=> ['date(trans.created_at) < :till AND posts.account_id=:account', {:till=>(till.to_date+1).to_s('%Y-%m-%d'), :account=>self.revenue_account_id}],:joins=>'inner join trans on trans.id=posts.trans_id',:order=>'created_at')
##					new_rev_balance=last_rev_post.balance if last_rev_post
##				end
##				rep[:final_balance]=(new_rev_balance||0)-(new_cash_balance||0)
##				rep[:previous_balance]=(old_rev_balance||0)-(old_cash_balance||0)
##				puts "new rev" + new_rev_balance.to_s
##				puts "new cash" + new_cash_balance.to_s
##				puts "old rev" + old_rev_balance.to_s
##				puts "old cash" + old_cash_balance.to_s
#				reps << rep
#			end
#		end
#		return reps
#	end
	def rights
		dict={}
		for r in roles
			dict[r.title]=r
			for t in r.rights
				dict[t.id]=t
			end
		end
		return dict
	end
	def has_right(id)
		return Right.find(:all, 
			:conditions=>"user_id=#{self.id} AND rights.id='#{id}'",
			:joins=>"inner join rights_roles on rights_roles.right_id=rights.id inner join roles_users on roles_users.role_id=rights_roles.role_id"
			).length >0 ? true : false
	end
	def has_rights(needed)
		r = rights
		for n in needed
			return true if r.include?(n) 
		end
		return false
	end
  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
      
    def password_required?
      crypted_password.blank? || !password.blank?
    end
#	CREATE_PAYMENTS_FOR_SALES=1
#	CHANGE_PAYMENTS_FOR_SALES=2
#	VIEW_PAYMENTS_FOR_SALES=3
#	DELETE_PAYMENTS_FOR_SALES=4
#	CREATE_PAYMENTS_FOR_PURCHASES=5
#	CHANGE_PAYMENTS_FOR_PURCHASES=6
#	VIEW_PAYMENTS_FOR_PURCHASES=7
#	DELETE_PAYMENTS_FOR_PURCHASES=8
#	CREATE_SALES=9
#	CHANGE_SALES=10
#	VIEW_SALES=11
#	DELETE_SALES=12
#	CREATE_PURCHASES=13
#	CHANGE_PURCHASES=14
#	VIEW_PURCHASES=15
#	DELETE_PURCHASES=16
#	CREATE_CLIENTS=17
#	CHANGE_CLIENTS=18
#	VIEW_CLIENTS=19
#	DELETE_CLIENTS=20
#	CREATE_PRODUCTS=25
#	CHANGE_PRODUCTS=26
#	VIEW_PRODUCTS=27
#	DELETE_PRODUCTS=28
#	CREATE_SUBSCRIPTIONS=29
#	CHANGE_SUBSCRIPTIONS=30
#	VIEW_SUBSCRIPTIONS=31
#	DELETE_SUBSCRIPTIONS=32
#	CREATE_ROLES=33
#	CHANGE_ROLES=34
#	VIEW_ROLES=35
#	DELETE_ROLES=36
#	CREATE_USERS=37
#	CHANGE_USERS=38
#	VIEW_USERS=39
#	DELETE_USERS=40
#	CREATE_SITES=41
#	CHANGE_SITES=42
#	VIEW_SITES=43
#	DELETE_SITES=44
#	CREATE_COUNTS=45
#	CHANGE_COUNTS=46
#	VIEW_COUNTS=47
#	DELETE_COUNTS=48
#	VIEW_COSTS=49
#	CREATE_ACCOUNTS=50
#	CHANGE_ACCOUNTS=51
#	VIEW_ACCOUNTS=52
#	DELETE_ACCOUNTS=53
#	CREATE_SERVICES=54
#	CHANGE_SERVICES=55
#	VIEW_SERVICES=56
#	DELETE_SERVICES=57
#	CREATE_COMBOS=58
#	CHANGE_COMBOS=59
#	VIEW_COMBOS=60
#	DELETE_COMBOS=61
#	CREATE_DISCOUNTS=62
#	CHANGE_DISCOUNTS=63
#	VIEW_DISCOUNTS=64
#	DELETE_DISCOUNTS=65
#	CREATE_WARRANTIES=66
#	CHANGE_WARRANTIES=67
#	VIEW_WARRANTIES=68
#	DELETE_WARRANTIES=69
#	CREATE_INTERNAL_CONSUMPTIONS=70
#	CHANGE_INTERNAL_CONSUMPTIONS=71
#	VIEW_INTERNAL_CONSUMPTIONS=72
#	DELETE_INTERNAL_CONSUMPTIONS=73
#	CREATE_SERIAL_NUMBERS=74
#	CHANGE_SERIAL_NUMBERS=75
#	VIEW_SERIAL_NUMBERS=76
#	DELETE_SERIAL_NUMBERS=77
#	CHANGE_PRICES=78
#	CREATE_VENDORS=79
#	CHANGE_VENDORS=80
#	VIEW_VENDORS=81
#	DELETE_VENDORS=82
#	CREATE_TRANSACTIONS=83
#	CHANGE_TRANSACTIONS=84
#	VIEW_TRANSACTIONS=85
#	DELETE_TRANSACTIONS=86
#	POST_COUNTS=87
#	CREATE_PRODUCTION_ORDERS=88
#	CHANGE_PRODUCTION_ORDERS=89
#	VIEW_PRODUCTION_ORDERS=90
#	DELETE_PRODUCTION_ORDERS=91
#	CREATE_PRODUCTION_PROCESSES=92
#	CHANGE_PRODUCTION_PROCESSES=93
#	VIEW_PRODUCTION_PROCESSES=94
#	DELETE_PRODUCTION_PROCESSES=95
#	START_PRODUCTION_ORDERS=96
#	FINISH_PRODUCTION_ORDERS=97
	CREATE_PAYMENTS_FOR_SALES='CREATE_PAYMENTS_FOR_SALES'
	CHANGE_PAYMENTS_FOR_SALES='CHANGE_PAYMENTS_FOR_SALES'
	VIEW_PAYMENTS_FOR_SALES='VIEW_PAYMENTS_FOR_SALES'
	DELETE_PAYMENTS_FOR_SALES='DELETE_PAYMENTS_FOR_SALES'
	CREATE_PAYMENTS_FOR_PURCHASES='CREATE_PAYMENTS_FOR_PURCHASES'
	CHANGE_PAYMENTS_FOR_PURCHASES='CHANGE_PAYMENTS_FOR_PURCHASES'
	VIEW_PAYMENTS_FOR_PURCHASES='VIEW_PAYMENTS_FOR_PURCHASES'
	DELETE_PAYMENTS_FOR_PURCHASES='DELETE_PAYMENTS_FOR_PURCHASES'
	CREATE_SALES='CREATE_SALES'
	CHANGE_SALES='CHANGE_SALES'
	VIEW_SALES='VIEW_SALES'
	DELETE_SALES='DELETE_SALES'
	CREATE_PURCHASES='CREATE_PURCHASES'
	CHANGE_PURCHASES='CHANGE_PURCHASES'
	VIEW_PURCHASES='VIEW_PURCHASES'
	DELETE_PURCHASES='DELETE_PURCHASES'
	CREATE_CLIENTS='CREATE_CLIENTS'
	CHANGE_CLIENTS='CHANGE_CLIENTS'
	VIEW_CLIENTS='VIEW_CLIENTS'
	DELETE_CLIENTS='DELETE_CLIENTS'
	CREATE_PRODUCTS='CREATE_PRODUCTS'
	CHANGE_PRODUCTS='CHANGE_PRODUCTS'
	VIEW_PRODUCTS='VIEW_PRODUCTS'
	DELETE_PRODUCTS='DELETE_PRODUCTS'
	CREATE_SUBSCRIPTIONS='CREATE_SUBSCRIPTIONS'
	CHANGE_SUBSCRIPTIONS='CHANGE_SUBSCRIPTIONS'
	VIEW_SUBSCRIPTIONS='VIEW_SUBSCRIPTIONS'
	DELETE_SUBSCRIPTIONS='DELETE_SUBSCRIPTIONS'
	CREATE_ROLES='CREATE_ROLES'
	CHANGE_ROLES='CHANGE_ROLES'
	VIEW_ROLES='VIEW_ROLES'
	DELETE_ROLES='DELETE_ROLES'
	CREATE_USERS='CREATE_USERS'
	CHANGE_USERS='CHANGE_USERS'
	VIEW_USERS='VIEW_USERS'
	DELETE_USERS='DELETE_USERS'
	CREATE_SITES='CREATE_SITES'
	CHANGE_SITES='CHANGE_SITES'
	VIEW_SITES='VIEW_SITES'
	DELETE_SITES='DELETE_SITES'
	CREATE_COUNTS='CREATE_COUNTS'
	CHANGE_COUNTS='CHANGE_COUNTS'
	VIEW_COUNTS='VIEW_COUNTS'
	DELETE_COUNTS='DELETE_COUNTS'
	VIEW_COSTS='VIEW_COSTS'
	CREATE_ACCOUNTS='CREATE_ACCOUNTS'
	CHANGE_ACCOUNTS='CHANGE_ACCOUNTS'
	VIEW_ACCOUNTS='VIEW_ACCOUNTS'
	DELETE_ACCOUNTS='DELETE_ACCOUNTS'
	CREATE_SERVICES='CREATE_SERVICES'
	CHANGE_SERVICES='CHANGE_SERVICES'
	VIEW_SERVICES='VIEW_SERVICES'
	DELETE_SERVICES='DELETE_SERVICES'
	CREATE_COMBOS='CREATE_COMBOS'
	CHANGE_COMBOS='CHANGE_COMBOS'
	VIEW_COMBOS='VIEW_COMBOS'
	DELETE_COMBOS='DELETE_COMBOS'
	CREATE_DISCOUNTS='CREATE_DISCOUNTS'
	CHANGE_DISCOUNTS='CHANGE_DISCOUNTS'
	VIEW_DISCOUNTS='VIEW_DISCOUNTS'
	DELETE_DISCOUNTS='DELETE_DISCOUNTS'
	CREATE_WARRANTIES='CREATE_WARRANTIES'
	CHANGE_WARRANTIES='CHANGE_WARRANTIES'
	VIEW_WARRANTIES='VIEW_WARRANTIES'
	DELETE_WARRANTIES='DELETE_WARRANTIES'
	CREATE_INTERNAL_CONSUMPTIONS='CREATE_INTERNAL_CONSUMPTIONS'
	CHANGE_INTERNAL_CONSUMPTIONS='CHANGE_INTERNAL_CONSUMPTIONS'
	VIEW_INTERNAL_CONSUMPTIONS='VIEW_INTERNAL_CONSUMPTIONS'
	DELETE_INTERNAL_CONSUMPTIONS='DELETE_INTERNAL_CONSUMPTIONS'
	CREATE_SERIAL_NUMBERS='CREATE_SERIAL_NUMBERS'
	CHANGE_SERIAL_NUMBERS='CHANGE_SERIAL_NUMBERS'
	VIEW_SERIAL_NUMBERS='VIEW_SERIAL_NUMBERS'
	DELETE_SERIAL_NUMBERS='DELETE_SERIAL_NUMBERS'
	CHANGE_PRICES='CHANGE_PRICES'
	CREATE_VENDORS='CREATE_VENDORS'
	CHANGE_VENDORS='CHANGE_VENDORS'
	VIEW_VENDORS='VIEW_VENDORS'
	DELETE_VENDORS='DELETE_VENDORS'
	CREATE_TRANSACTIONS='CREATE_TRANSACTIONS'
	CHANGE_TRANSACTIONS='CHANGE_TRANSACTIONS'
	VIEW_TRANSACTIONS='VIEW_TRANSACTIONS'
	DELETE_TRANSACTIONS='DELETE_TRANSACTIONS'
	POST_COUNTS='POST_COUNTS'
	CREATE_PRODUCTION_ORDERS='CREATE_PRODUCTION_ORDERS'
	CHANGE_PRODUCTION_ORDERS='CHANGE_PRODUCTION_ORDERS'
	VIEW_PRODUCTION_ORDERS='VIEW_PRODUCTION_ORDERS'
	DELETE_PRODUCTION_ORDERS='DELETE_PRODUCTION_ORDERS'
	CREATE_PRODUCTION_PROCESSES='CREATE_PRODUCTION_PROCESSES'
	CHANGE_PRODUCTION_PROCESSES='CHANGE_PRODUCTION_PROCESSES'
	VIEW_PRODUCTION_PROCESSES='VIEW_PRODUCTION_PROCESSES'
	DELETE_PRODUCTION_PROCESSES='DELETE_PRODUCTION_PROCESSES'
	START_PRODUCTION_ORDERS='START_PRODUCTION_ORDERS'
	FINISH_PRODUCTION_ORDERS='FINISH_PRODUCTION_ORDERS'

end
