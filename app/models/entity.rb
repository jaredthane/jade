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


class Entity < ActiveRecord::Base
	validates_presence_of(:name, :message => "Debe introducir el nombre de la entidad.")
  validates_uniqueness_of(:name, :message => "El nombre de entidad ya existe.") 
  
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
	def process_subscriptions
		#################################################################################################
		# If the client has subscriptions to be processed, will create an order with a line for each.
		#################################################################################################
		# figure out the cutoff date
  	cutoff_date=Date.today
  	cutoff_date=cutoff_date+1 if Date.today.wday==6
    # this hash will have a list of subs for each vendor
	  subscriptions = {}
	  for sub in Subscription.find(:all, :conditions=>'(subscriptions.end_date > CURRENT_DATE OR subscriptions.end_date is null) AND (subscriptions.end_times>0 OR subscriptions.end_times is null) AND (subscriptions.client_id=' + client.id.to_s + ')' )
	  	# check if this sub needs to be processed
	    if sub.last_line
        if sub.last_line.received.to_date >> sub.frequency <= cutoff_date
        	# add the vendor if its not already in the list
          subscriptions[sub.vendor_id] = [] if !subscriptions[sub.vendor_id]
          # add the sub to the list
          subscriptions[sub.vendor_id] << sub
        end
      else  # this sub has never been processed, lets do it now
        subscriptions[sub.vendor_id] = [] if !subscriptions[sub.vendor_id]
        subscriptions[sub.vendor_id] << sub
      end
 	  	# Now we got a nice list grouped by vendor, lets make the subs
  	  for vendor_id, list in subscriptions
			  o=Order.create(:vendor => list[0].vendor, :client => list[0].client,:user => User.current_user, :order_type_id => 1, :last_batch =>true)
			  for sub in list
			  	sub.process(o)
		    end
		    # now for the accounting
				sale = Trans.create(:order => o, :comments => o.comments)
				vendor = Post.create(:trans=>sale, :account => o.vendor.revenue_account, :value=>o.total_price, :post_type_id =>2, :balance => (o.vendor.revenue_account.balance||0) + (o.total_price||0))
				client = Post.create(:trans=>sale, :account => o.client.cash_account, :value=>o.total_price_with_tax, :post_type_id =>1, :balance => (o.client.cash_account.balance||0) + (o.total_price||0))
				tax    = Post.create(:trans=>sale, :account => o.vendor.tax_account, :value=>o.total_tax, :post_type_id =>2, :balance => (o.vendor.tax_account.balance||0) + (o.total_price||0))
				inventory_cost = o.inventory_value
				# if the sub included inventory items, we have to make that transaction also...
				if inventory_cost > 0 
					itrans = Trans.create(:order => o, :comments => o.comments)
					inventory = Post.create(:trans=>itrans, :account => o.vendor.inventory_account, :value=>o.inventory_cost, :post_type_id =>2, :balance => (o.vendor.inventory_account.balance||0) - (o.inventory_cost||0))
					expense = Post.create(:trans=>itrans, :account => o.vendor.expense_account, :value=>o.inventory_cost, :post_type_id =>1, :balance => (o.vendor.expense_account.balance||0) + (o.inventory_cost||0))
				end
		  end
  	end
	end

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
  def self.search(search, page, entity_type='all', user_id=0, filter='')
  	#puts "search=" + search
  	search = search || ""
  	#puts "search=" + search
  	case entity_type
			when 'clients'
				condition = "(entities.name like '%" + search +"%' OR client_group.name like '%" + search +"%' OR entities.id like '%" + search +"%' OR users.login like '%" + search +"%') AND (entity_type_id = 2 OR entity_type_id = 5)"
			when 'end_users'
				condition = "(entities.name like '%" + search +"%' OR client_group.name like '%" + search +"%' OR entities.id like '%" + search +"%' OR users.login like '%" + search +"%') AND entity_type_id = 2"
			when 'wholesale_clients'
				condition = "(entities.name like '%" + search +"%' OR client_group.name like '%" + search +"%' OR entities.id like '%" + search +"%' OR users.login like '%" + search +"%') AND entity_type_id = 5"
			when 'vendors'
				condition = "(entities.name like '%" + search +"%' OR entities.id like '%" + search +"%' OR users.login like '%" + search +"%') AND entity_type_id = 1"
			when 'sites'
				condition = "(entities.name like '%" + search +"%' OR site_group.name like '%" + search +"%' OR entities.id like '%" + search +"%') AND entity_type_id = 3"
			else
				condition = "(entities.name like '%" + search +"%' OR client_group.name like '%" + search +"%' OR site_group.name like '%" + search +"%' OR entities.id like '%" + search +"%' OR users.login like '%" + search +"%') AND entities.id!=1"
  	end
  	condition += ' AND entities.user_id = ' + user_id.to_s if user_id != 0 
  	if entity_type=='clients' or entity_type=='end_users' or entity_type=='wholesale_clients'
  	    # only show for this site, but always include anonimo and no spcificado
      	condition += ' AND (entities.site_id = ' + User.current_user.location_id.to_s + ' or entities.id=3 or entities.id=4) ' 
    end
  	#puts "condition=" + condition
		paginate :per_page => 20, :page => page,
		       :conditions => condition,
		       :joins => 'left join price_group_names as client_group on client_group.id=entities.price_group_name_id left join price_groups on entities.price_group_id=price_groups.id left join price_group_names as site_group on site_group.id = price_groups.price_group_name_id left join users on users.id=entities.user_id',
		       :order => 'name'
	end
	def self.find_all_clients
	  condition = "(entity_type_id = 2 OR entity_type_id = 5)"
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
		puts "product.id=" + product.id.to_s
		puts "self.id=" + self.id.to_s
		if product.inventories.find_by_entity_id(self.id)
			return product.inventories.find_by_entity_id(self.id).quantity
		else
			return 0
		end
	end
end
