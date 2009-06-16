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

class Subscription < ActiveRecord::Base
	belongs_to :client, :class_name => "Entity", :foreign_key => "client_id"
	belongs_to :vendor, :class_name => "Entity", :foreign_key => "vendor_id"
	belongs_to :product
	belongs_to :last_line, :class_name => "Line", :foreign_key => "last_line_id"
	def client_name
 		client.name if client
	end
	def client_name=(name)
		self.client = Entity.find_by_name(name) unless name.blank?
	end
############################################################################################
# DEPRECATED - DEPRECATED - DEPRECATED - DEPRECATED - DEPRECATED - DEPRECATED - DEPRECATED #
############################################################################################
#	def process(order=nil, received=nil)
#		# processes the subscription for the next unprocessed period no matter what.
#		# If you give it an order, it will append the new line to the specified order
#		# if not, it will make an appropriate order and append the line to it.
#		self.end_times -= 1 if self.end_times
#		if !received
#			if self.last_line
#				received=self.last_line.received.to_date >> self.frequency
#			else
#				received=self.created_at
#			end
#		end
#		if !order
#			order = Order.create(:received=>received, :created_at=>received, :vendor => self.vendor, :client => self.client,:user => User.current_user, :order_type_id => 1, :last_batch =>true)
#		end
#    l=Line.create(:created_at=>received, :order => order, :product => self.product, :quantity=> self.quantity, :price => self.price, :received =>received)
#    self.last_line_id = l.id
#    self.save
#    return l
#	end
#def self.to_process()
#		list = find(:all,
#								:conditions => '(subscriptions.end_date > CURRENT_DATE OR subscriptions.end_date is null) AND (subscriptions.end_times>0 OR subscriptions.end_times is null) AND (subscriptions.next_order_date <= CURRENT_DATE) AND (subscriptions.next_order_date > CURRENT_DATE - interval 1 month) AND (entities.active=true) AND unpaid.client_id is null',								
#								:joins => 'inner join entities on entities.id=subscriptions.client_id left join (select client_id from orders where deleted=false AND (amount_paid < grand_total OR amount_paid is null) group by client_id) as unpaid on unpaid.client_id=entities.id'
#							)
#	end

	def self.to_process(search)
		search = search || ""
  	puts "search="+ search
  	condition="(subscriptions.end_date > CURRENT_DATE OR subscriptions.end_date is null) AND (subscriptions.end_times>0 OR subscriptions.end_times is null) AND (subscriptions.next_order_date <= CURRENT_DATE) AND (subscriptions.next_order_date > CURRENT_DATE - interval 1 month) AND (entities.active=true) AND unpaid.client_id is null AND ("
  	fields_to_search=[]
  	join=""
  	search_words=[]
  	words = search.downcase.split( / *"(.*?)" *| / ) 
  	for word in words
  		puts 'word=' + word
  		if word[0..3]=='tipo'
  			if word[4..word.length+1] == ':credito' or word[4..word.length+1] == ':wholesale_clients'
  				fields_to_search << "entities.name"
  				fields_to_search << "users.login"
  				condition += " AND (entities.site_id = " + User.current_user.location_id.to_s + " or entities.id=3 or entities.id=4) AND entity_type_id = 5"
  			elsif word[4..word.length+1] == ':consumidor' or word[4..word.length+1] == ':end_users'
  				fields_to_search << "entities.name"
  				fields_to_search << "users.login"
  				condition += " AND (entities.site_id = " + User.current_user.location_id.to_s + " or entities.id=3 or entities.id=4) AND entity_type_id = 2"
  			elsif word[4..word.length+1] == ':cliente' or word[4..word.length+1] == ':clients'
  				fields_to_search << "entities.name"
  				fields_to_search << "users.login"
  				condition += " AND (entities.site_id = " + User.current_user.location_id.to_s + ") AND (entity_type_id = 2 OR entity_type_id = 2)"
  			end
  		elsif word[0..5]=='asesor'
  			condition += ' AND entities.user_id=' + word[7..word.length+1].to_s if word[7..word.length+1].to_s != ""
  		elsif word[0..2]=='dia'
  			condition += ' AND entities.active=TRUE AND entities.subscription_day=' + word[4..word.length+1].to_s if word[4..word.length+1].to_s != ""
  		elsif word[0..1]=='id'
  			condition += ' AND entities.id=' + word[3..word.length+1].to_s
  		else
  			search_words << word
  		end
  	end
   	#puts 'condition=' + condition
 		puts 'fields_to_search'+ fields_to_search.inspect
  	#add in actual searching of fields
  	condition += " AND ("
  	for word in search_words
  		puts 'searchword=' + word
  		condition+= " AND ("
  		for field in fields_to_search
  			condition+= " OR " + field + " like '%" + word + "%'"
  		end
  		condition += ")"
  	end
  	condition += "))"
   	puts 'condition=' + condition
   	condition =condition.gsub("( AND ", "(")
   	condition =condition.gsub("( OR ", "(")
   	condition =condition.gsub("()", "")
   	condition =condition.gsub("()", "")
   	condition =condition.gsub("()", "")
   	condition =condition.gsub("AND )", ")")
   	condition =condition.gsub("AND )", ")")
   	condition =condition.gsub(/AND $/, "")
   	condition="" if condition == " AND "	
   	puts 'condition=' + condition
	
		list = find(:all,
								:conditions => condition,								
								:joins => 'inner join entities on entities.id=subscriptions.client_id left join (select client_id from orders where deleted=false AND (amount_paid < grand_total OR amount_paid is null) group by client_id) as unpaid on unpaid.client_id=entities.id  left join users on users.id=entities.user_id'
							)
	end
	def self.to_process_client(client)
		list= find(:all, 
							 :conditions=>'(subscriptions.end_date > CURRENT_DATE OR subscriptions.end_date is null) AND (subscriptions.end_times>0 OR subscriptions.end_times is null) AND (entities.active=true) AND entities.id=' + client.id.to_s,
							 :joins => 'inner join entities on entities.id=subscriptions.client_id')
	end
#	def self.process
#		list= find(:all, 
#							 :conditions=>'(subscriptions.end_date > CURRENT_DATE OR subscriptions.end_date is null) AND (subscriptions.end_times>0 OR subscriptions.end_times is null) AND (subscriptions.next_order_date <= CURRENT_DATE) AND (entities.active=true)',
#							 :joins => 'inner join entities on entities.id=subscriptions.client_id')
#		process_list(list)
#	end
	def self.process(list)
		subs={} # a hash of hashes with clients on the first and vendors on the second
		for sub in list
			#puts "client name="+sub.client.name
			subs[sub.client] = {} if !subs[sub.client]
			subs[sub.client][sub.vendor] = [] if !subs[sub.client][sub.vendor]
			subs[sub.client][sub.vendor] << sub	
			#puts "subs[sub.client].inspect" + subs[sub.client].inspect
		end	
		# Now we got a nice list grouped by vendor, lets make the subs
	  for client, vendor_list in subs
	  	for vendor, list in vendor_list
				o=Order.create(:vendor => vendor, :client => client,:user => User.current_user, :order_type_id => 1, :last_batch =>true)
			  order_received=nil
			  total=0
			  for sub in list
#  	  		##puts "adding a line for: "+sub.name
			  	l=Line.create(:created_at=>sub.next_order_date, :order => o, :product => sub.product, :quantity=> sub.quantity, :price => sub.price, :received =>sub.next_order_date)
					s=Subscription.find(sub.id)
					s.next_order_date = s.next_order_date.to_date >> 1
					s.save
			  	order_received=l.received if !order_received
			  	order_received=l.received if l.received > order_received
			  	total += l.total_price_with_tax
		    end
		    #puts "o.id=" + o.id.to_s
		    #puts o.errors.inspect
		    o=Order.find(o.id)
		    o.received=order_received
		    o.grand_total=total
		    o.save
		    # now for the accounting
				sale = Trans.create(:order => o, :comments => o.comments)
				vendor = Post.create(:trans=>sale, :account => o.vendor.revenue_account, :value=>o.total_price, :post_type_id =>Post::CREDIT)
				client = Post.create(:trans=>sale, :account => o.client.cash_account, :value=>o.total_price_with_tax, :post_type_id =>Post::DEBIT)
				tax    = Post.create(:trans=>sale, :account => o.vendor.tax_account, :value=>o.total_tax, :post_type_id =>Post::CREDIT)
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
	def self.fast_process(list)
		for sub in list
			o=Order.create(:vendor => sub.vendor, :client => sub.client,:user => User.current_user, :order_type_id => 1, :last_batch =>true)
			l=Line.create(:created_at=>sub.next_order_date, :order => o, :product => sub.product, :quantity=> sub.quantity, :price => sub.price, :received =>sub.next_order_date)
			o=Order.find(o.id)
			o.received=sub.next_order_date
			o.grand_total=l.total_price_with_tax
			o.save
			s=Subscription.find(sub.id)
			s.next_order_date = sub.next_order_date.to_date >> sub.frequency
			s.save
		end
			#puts "Length:"+ list.length.to_s
#	    # now for the accounting
#			sale = Trans.create(:order => o, :comments => o.comments)
#			vendor = Post.create(:trans=>sale, :account => o.vendor.revenue_account, :value=>o.total_price, :post_type_id =>Post::CREDIT)
#			client = Post.create(:trans=>sale, :account => o.client.cash_account, :value=>o.total_price_with_tax, :post_type_id =>Post::DEBIT)
#			tax    = Post.create(:trans=>sale, :account => o.vendor.tax_account, :value=>o.total_tax, :post_type_id =>Post::CREDIT)
#			inventory_cost = o.inventory_value
#			# if the sub included inventory items, we have to make that transaction also...
#			if inventory_cost > 0 
#				itrans = Trans.create(:order => o, :comments => o.comments)
#				inventory = Post.create(:trans=>itrans, :account => o.vendor.inventory_account, :value=>o.inventory_cost, :post_type_id =>2, :balance => (o.vendor.inventory_account.balance||0) - (o.inventory_cost||0))
#				expense = Post.create(:trans=>itrans, :account => o.vendor.expense_account, :value=>o.inventory_cost, :post_type_id =>1, :balance => (o.vendor.expense_account.balance||0) + (o.inventory_cost||0))
#			end
#	  end
	end
############################################################################################
# DEPRECATED - DEPRECATED - DEPRECATED - DEPRECATED - DEPRECATED - DEPRECATED - DEPRECATED #
############################################################################################
#	def create_order_for_client(subs)
#	  #puts "subs:" +  subs.inspect
#	  for vendor_id, list in subs
#	    #puts "vendor_id=" + vendor_id.inspect
#	    #puts "list=" + list.inspect
#	    o=Order.create(:vendor => list[0].vendor, :client => list[0].client,:user => User.current_user, :order_type_id => 1, :last_batch =>true)
#	    for sub in list
#	    	sub.end_times -= 1 if sub.end_times
#	    	if sub.last_line
#			  	received=sub.last_line.received.to_date >> sub.frequency
#			  else
#			  	received=sub.created_at
#			  end
#	      l=Line.create(:order => o, :product => sub.product, :quantity=> sub.quantity, :price => sub.price, :received =>received)
#	      #puts "last line = " + sub.last_line.inspect
#	      #puts "l = " + l.inspect
#	      #puts "sub=" + sub.inspect
#	      sub.last_line_id = l.id
#	      #puts "last line after= " + sub.last_line.inspect
#        sub.save
#	      #puts "make sure it saved= " + Subscription.find(sub.id).last_line.inspect
#      end
#		  sale = Trans.create(:order => o, :comments => o.comments)
#		  vendor = Post.create(:trans=>sale, :account => o.vendor.revenue_account, :value=>o.total_price, :post_type_id =>2, :balance => (o.vendor.revenue_account.balance||0) + (o.total_price||0))
#		  client = Post.create(:trans=>sale, :account => o.client.cash_account, :value=>o.total_price_with_tax, :post_type_id =>1, :balance => (o.client.cash_account.balance||0) + (o.total_price||0))
#		  tax    = Post.create(:trans=>sale, :account => o.vendor.tax_account, :value=>o.total_tax, :post_type_id =>2, :balance => (o.vendor.tax_account.balance||0) + (o.total_price||0))
#		  inventory_cost = o.inventory_value
#		  if inventory_cost > 0 
#				itrans = Trans.create(:order => o, :comments => o.comments)
#				inventory = Post.create(:trans=>itrans, :account => o.vendor.inventory_account, :value=>o.inventory_cost, :post_type_id =>2, :balance => (o.vendor.inventory_account.balance||0) - (o.inventory_cost||0))
#				expense = Post.create(:trans=>itrans, :account => o.vendor.expense_account, :value=>o.inventory_cost, :post_type_id =>1, :balance => (o.vendor.expense_account.balance||0) + (o.inventory_cost||0))
#			end
#    end
#	end
	
	###################################################################################
	# Returns the upc of the product requested
	###################################################################################
	def product_name
 	 product.name if product
	end
	
	###################################################################################
	# Sets the product requested by the upc provided
	###################################################################################
	def product_name=(name)
		if !name.blank?		
			prod = Product.find_by_name(name)
			if prod != nil
				self.product_id = prod.id
			end
		end
	end
############################################################################################
# DEPRECATED - DEPRECATED - DEPRECATED - DEPRECATED - DEPRECATED - DEPRECATED - DEPRECATED #
############################################################################################
#	def create_orders
#	  for o in Order.find(:all, :conditions =>'last_batch=True')
#  		o.last_batch=false
#  		o.save
#  	end
#  	cutoff_date=Date.today
#  	cutoff_date=cutoff_date+1 if Date.today.wday==6
#  	for client in Entity.find(:all, :conditions=> '(entity_type_id=2 or entity_type_id=5) AND site_id=' + User.current_user.location_id.to_s)
#  	  subs_to_fill_for_client = {}
#  	  #puts "asubs_to_fill_for_client" + subs_to_fill_for_client.inspect
#  	  for sub in Subscription.find(:all, :conditions=>'(subscriptions.end_date > CURRENT_DATE OR subscriptions.end_date is null) AND (subscriptions.end_times>0 OR subscriptions.end_times is null) AND (subscriptions.client_id=' + client.id.to_s + ')' )
#  	    if sub.last_line
#	        if sub.last_line.received.to_date >> sub.frequency <= cutoff_date
#  	        #puts "bsubs_to_fill_for_client" + subs_to_fill_for_client.inspect
#	          subs_to_fill_for_client[sub.vendor_id] = [] if !subs_to_fill_for_client[sub.vendor_id]
#  	        #puts "csubs_to_fill_for_client" + subs_to_fill_for_client.inspect
#	          subs_to_fill_for_client[sub.vendor_id] << sub
#	        end
#	      else
#          #puts "dsubs_to_fill_for_client" + subs_to_fill_for_client.inspect
#          subs_to_fill_for_client[sub.vendor_id] = [] if !subs_to_fill_for_client[sub.vendor_id]
#  	      #puts "esubs_to_fill_for_client" + subs_to_fill_for_client.inspect  
#          subs_to_fill_for_client[sub.vendor_id] << sub
#	      end
#  	  end
#  	  #puts "fsubs_to_fill_for_client" + subs_to_fill_for_client.inspect
#  	  #puts "lenght="+subs_to_fill_for_client.length.to_s
#  	  create_order_for_client(subs_to_fill_for_client) if subs_to_fill_for_client.length > 0
#  	end
#	end
	def expiration
		if end_date
			return end_date.to_date
		else
			return nil
		end
	end
	def self.search(search, page)
		if search
			if search[0..7] == 'inactivo'
				paginate :per_page => 20, :page => page,
				       :conditions => ['((subscriptions.end_date <= CURRENT_DATE) OR (subscriptions.end_times<1) AND (products.name like :search or products.upc like :search or clients.name like :search)) AND clients.site_id = :site', {:search => "%#{search[8..search.length]}%", :site => User.current_user.location_id.to_s}],
				       :order => 'products.name',
				       :joins => 'inner join products on products.id = subscriptions.product_id inner join entities as clients on clients.id = subscriptions.client_id'
			elsif search[0..5] == 'activo'
				paginate :per_page => 20, :page => page,
				       :conditions => ['(subscriptions.end_date > CURRENT_DATE OR subscriptions.end_date is null) AND (subscriptions.end_times>0 OR subscriptions.end_times is null) AND (products.name like :search or products.upc like :search or clients.name like :search) AND clients.site_id = :site', {:search => "%#{search[6..search.length]}%", :site => User.current_user.location_id.to_s}],
				       :order => 'products.name',
				       :joins => 'inner join products on products.id = subscriptions.product_id inner join entities as clients on clients.id = subscriptions.client_id'
			else
			  paginate :per_page => 20, :page => page,
			       :conditions => ['(products.name like :search or products.upc like :search or clients.name like :search) AND clients.site_id = :site', {:search => "%#{search}%", :site => User.current_user.location_id.to_s}],
			       :order => 'products.name',
			       :joins => 'inner join products on products.id = subscriptions.product_id inner join entities as clients on clients.id = subscriptions.client_id'
			end
		else
			paginate :per_page => 20, :page => page,
			       :conditions => ['clients.site_id = :site', {:site => User.current_user.location_id.to_s}],
			       :order => 'products.name',
			       :joins => 'inner join products on products.id = subscriptions.product_id inner join entities as clients on clients.id = subscriptions.client_id'
		end
	end
	def price(price_group = User.current_user.current_price_group)
	    return (self.product.price||0) * (self.relative_price||0) + (self.fixed_price||0)
	end
end
