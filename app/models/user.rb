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
	has_many :roles_users
	has_many :roles, :through => :roles_users
	has_and_belongs_to_many :roles
  validates_presence_of     :login, :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :login, :email, :case_sensitive => false
  before_save :encrypt_password
  
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :password, :password_confirmation
	
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
