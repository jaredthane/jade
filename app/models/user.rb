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
	has_many :receipts
	has_many :roles_users
	has_many :roles, :through => :roles_users
	has_and_belongs_to_many :roles
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
  attr_accessible :login, :email, :password, :password_confirmation, :do_accounting, :name, :date, :today, :roles, :roles_users, :personal_account_id, :cash_account_id, :revenue_account_id, :default_received
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
	logger.debug "self.price_group_name=" + self.price_group_name.name
	logger.debug "looking in location=" + self.location.name
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
	def self.sales_reps_data(from, till, site)
		reps=[]
		for r in User.find_all_by_location_id(site)
			if r.clients.length>0
				rep={:user=>r, :previous_balance=>0, :num_receipts=>0, :revenue=>0, :num_payments=>0, :cash_received=>0, :final_balance=>0}
				rep[:num_receipts] = Receipt.count(:all, 
										:conditions => ['clients.user_id=:rep_id AND date(receipts.created_at) >=:from AND date(receipts.created_at) <= :till', {:from=>from.to_date.to_s('%Y-%m-%d'), :till=>till.to_date.to_s('%Y-%m-%d'), :rep_id=>rep[:user].id}],
										:joins=>'inner join orders on orders.id=receipts.order_id inner join entities as clients on clients.id=orders.client_id')
				revenue_posts = Post.find(:all, 
						:conditions=> ['date(trans.created_at) >=:from AND date(trans.created_at) <= :till AND posts.account_id=:account', {:from=>from.to_date.to_s('%Y-%m-%d'), :till=>till.to_date.to_s('%Y-%m-%d'), :account=>rep[:user].revenue_account_id}],
						:joins=>'inner join trans on trans.id=posts.trans_id')
				rep[:revenue]=revenue_posts.inject(0) { |result, element| result + element.value*element.post_type_id*-1}.to_s
				rep[:num_payments] = Payment.count(:all, 
										:conditions=> ['clients.user_id=:rep_id AND date(payments.created_at) >=:from AND date(payments.created_at) <= :till', {:from=>from.to_date.to_s('%Y-%m-%d'), :till=>till.to_date.to_s('%Y-%m-%d'), :rep_id=>rep[:user].id}],
										:joins=>'inner join orders on orders.id=payments.order_id inner join entities as clients on clients.id=orders.client_id')
				rep[:cash_received] = Post.find(:all, 
						:conditions=> ['date(trans.created_at) >=:from AND date(trans.created_at) <= :till AND posts.account_id=:account', {:from=>from.to_date.to_s('%Y-%m-%d'), :till=>till.to_date.to_s('%Y-%m-%d'), :account=>rep[:user].cash_account_id}],
						:joins=>'inner join trans on trans.id=posts.trans_id'
					).collect(&:value).sum
				rep[:facturas_pendientes]=rep[:num_receipts]-rep[:num_payments]
				Order.count(:all,
					:conditions=>'amount_paid<grand_total'
				
				)
				new_cash_balance, new_rev_balance, old_cash_balance, old_rev_balance=nil, nil, nil, nil
				if r.cash_account
#					new_cash_balance=r.cash_account.balance
					logger.debug "geting first_cash_post "
					first_cash_post=Post.last(:conditions=> ['date(trans.created_at) < :from AND posts.account_id=:account', {:from=>from.to_date.to_s('%Y-%m-%d'), :account=>rep[:user].cash_account_id}],:joins=>'inner join trans on trans.id=posts.trans_id',:order=>'created_at')
					old_cash_balance=first_cash_post.balance  if first_cash_post
					
					logger.debug "geting last_cash_post "
					last_cash_post=Post.last(:conditions=> ['date(trans.created_at) < :till AND posts.account_id=:account', {:till=>(till.to_date+1).to_s('%Y-%m-%d'), :account=>rep[:user].cash_account_id}],:joins=>'inner join trans on trans.id=posts.trans_id',:order=>'created_at')
					new_cash_balance=last_cash_post.balance  if last_cash_post
				end
				if r.revenue_account
#					new_rev_balance=r.revenue_account.balance
					logger.debug "geting first_rev_post "
					first_rev_post=Post.last(:conditions=> ['date(trans.created_at) < :from AND posts.account_id=:account', {:from=>from.to_date.to_s('%Y-%m-%d'), :account=>rep[:user].revenue_account_id}],:joins=>'inner join trans on trans.id=posts.trans_id',:order=>'created_at')
					old_rev_balance=first_rev_post.balance if first_rev_post
					logger.debug "geting last_rev_post "
					last_rev_post=Post.last(:conditions=> ['date(trans.created_at) < :till AND posts.account_id=:account', {:till=>(till.to_date+1).to_s('%Y-%m-%d'), :account=>rep[:user].revenue_account_id}],:joins=>'inner join trans on trans.id=posts.trans_id',:order=>'created_at')
					new_rev_balance=last_rev_post.balance if last_rev_post
				end
				rep[:final_balance]=(new_rev_balance||0)-(new_cash_balance||0)
				rep[:previous_balance]=(old_rev_balance||0)-(old_cash_balance||0)
				puts "new rev" + new_rev_balance.to_s
				puts "new cash" + new_cash_balance.to_s
				puts "old rev" + old_rev_balance.to_s
				puts "old cash" + old_cash_balance.to_s
				reps << rep
			end
		end
		return reps
	end
	
	
	def rights
		rights=[]
		for r in roles
			rights << r.title
		end
		return rights
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
    
    
end
