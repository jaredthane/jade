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

class Payment < ActiveRecord::Base
	belongs_to :order
	belongs_to :payment_method
	belongs_to :user
	has_many :transactions, :class_name => "Trans"
	
	attr_accessor :old_version
	def old(attribute=nil)
	  return nil if !self.id
    self.old_version=Payment.find_by_id(self.id)if !self.old_version
    return self.old_version.attributes[attribute] if attribute
    return self.old_version
	end
	before_save :pre_save
	def pre_save
		self.transactions << new_transaction
	end
	after_save :post_save
	def post_save
	  order.amount_paid += self.amount - (old('amount') || 0)
		order.save
		save_related(self.transactions)
	end 
	def new_transaction
		logger.debug "self.amount=#{self.amount.to_s}"
		logger.debug "old('amount')=#{old('amount').to_s}"
		logger.debug "old.amount =#{old.amount .to_s}"
		if old
		  amount = self.amount - old.amount 
		else
			amount = self.amount
		end
	  
	  if self.order
	    t = Trans.new( :created_at=>User.current_user.today,:user=>User.current_user, :payment_id => self.id, :comments => self.order.comments, :tipo => 'Pago de ' + self.order.order_type.name)
	  else
	    t = Trans.new( :created_at=>User.current_user.today,:user=>User.current_user, :payment_id => self.id, :tipo=> 'Pago')
	  end
	  case order.order_type_id
		when 1 # Sale
			t.posts << Post.new(:trans=>t, :account => self.order.vendor.cash_account, :value=>amount, :post_type_id =>Post::DEBIT)
			t.posts << Post.new(:trans=>t, :account => self.order.client.cash_account, :value=>amount, :post_type_id =>Post::CREDIT)
		when 2 # Purchase
			t.posts << Post.new(:trans=>t, :account => self.order.vendor.cash_account, :value=>amount, :post_type_id =>Post::DEBIT)
			t.posts << Post.new(:trans=>t, :account => self.order.client.cash_account, :value=>amount, :post_type_id =>Post::CREDIT)
		end
		return t
	end
  ##################################################################################################
  # Receives a list of related objects and saves them
  # Can be used for movements, transactions, lines, or other objects
  # Set update=true if you want it to save existing objects (like for updating lines)
  #################################################################################################
	def save_related(list, update=false, include_errors=true)
	  for item in list
	  	if item
    	  item.payment_id=self.id
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
	#################################################################################################
	# Holds a copy of the old version of this object for reference
	# By storing it in a accessor, we'll never have to load it more than once
	#################################################################################################
	def void=(num)
	  self.canceled=num
	end
	def void
	  return true if canceled
	  return false
	end
	def amount
	  return 0 if self.void
		return (self.presented||0)-(self.returned||0)
	end
	def self.search(search, page, from=Date.today, till=Date.today, sites=[User.current_user.location_id])
		site_string=''
		for site in sites
			site_string+= ' OR 'if site_string !=''
			site_string+=' orders.vendor_id=' + site.to_s
		end
  	paginate :per_page => 20, :page => page,
		         :conditions => ['date(payments.created_at) >=:from AND date(payments.created_at) <= :till AND (payments.order_id like :search OR orders.receipt_number like :search OR payment_methods.name like :search ) AND ('+site_string+')', {:from=>from.to_date.to_s('%Y-%m-%d'), :till=>till.to_date.to_s('%Y-%m-%d'), :search => "%#{search}%"}],
		         :order => 'orders.receipt_number',
		         :joins => 'inner join orders on orders.id = payments.order_id inner join payment_methods on payment_methods.id = payments.payment_method_id inner join users on payments.user_id=users.id '

	end
	def self.search_wo_pagination(search, from=Date.today, till=Date.today, sites=[User.current_user.location_id])
		site_string=''
		for site in sites
			site_string+= ' OR 'if site_string !=''
			site_string+=' orders.vendor_id=' + site.to_s
		end
  	find :all,
		         :conditions => ['date(payments.created_at) >=:from AND date(payments.created_at) <= :till AND (payments.payment_id like :search OR payments.payment_id like :search OR payment_methods.name like :search ) AND ('+site_string+')', {:from=>from.to_date.to_s('%Y-%m-%d'), :till=>till.to_date.to_s('%Y-%m-%d'), :search => "%#{search}%"}],
		         :order => 'orders.receipt_number',
		         :joins => 'inner join orders on orders.id = payments.order_id inner join payment_methods on payment_methods.id = payments.payment_method_id inner join users on payments.user_id=users.id'
	end
end
