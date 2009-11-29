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
	before_save :prepare_transactions
	after_save :create_transactions
	attr_accessor :amt
	def prepare_transactions
		if User.current_user.do_accounting
			self.amount=self.presented-self.returned
			if new_record?
				amt=self.amount
			else
				amt = self.amount - old.amount
			end
			@amt=amt
		end
	end
	def create_transactions
		puts "running here.."
  	if self.order
			puts "running here too.."
  		order.amount_paid+=self.amount
  		order.save
	    trans = Trans.create(:is_payment=>true, :created_at=>User.current_user.today,:user=>User.current_user, :order_id => self.id, :comments => self.order.comments, :tipo => 'Pago de ' + self.order.order_type.name)
#	    trans.tipo='Pago por' + self.order.order_type.name
	  else
	    trans = Trans.create(:is_payment=>true, :created_at=>User.current_user.today,:user=>User.current_user, :order_id => self.id, :tipo=> 'Pago')
#	  trans.tipo='Pago'
	  end
		case order.order_type_id
		when 1 # Sale
			debit = Post.create(:trans=>trans, :account => self.order.cash_account, :value=>@amt, :post_type_id =>Post::DEBIT)
			credit = Post.create(:trans=>trans, :account => self.order.client.cash_account, :value=>@amt, :post_type_id =>Post::CREDIT)
		when 2 # Purchase
			debit = Post.create(:trans=>trans, :account => self.order.vendor.cash_account, :value=>@amt, :post_type_id =>Post::DEBIT)
			credit = Post.create(:trans=>trans, :account => self.order.client.cash_account, :value=>@amt, :post_type_id =>Post::CREDIT)
		end
	end
	def cancel
		if self.order
  		order.amount_paid-=self.amount
  		order.save
	    trans = Trans.create(:is_payment=>true, :created_at=>User.current_user.today,:user=>User.current_user, :order => self.id, :comments => self.order.comments + 'Cancelacion de Pago #' + self.order.id.to_s, :tipo => 'Cancelacion de Pago')
#	    trans.tipo='Cancelacion de Pago por' + self.order.order_type.name
	  else
	    trans = Trans.create(:is_payment=>true, :created_at=>User.current_user.today,:user=>User.current_user, :order => self.id, :tipo=> 'Cancelacion de Pago')
#	    trans.tipo='Devolucion de Pago'
	  end
		case order.order_type_id
		when 1 # Sale
			debit = Post.create(:trans=>trans, :account => self.order.cash_account, :value=>self.amount, :post_type_id =>Post::CREDIT)
			credit = Post.create(:trans=>trans, :account => self.order.client.cash_account, :value=>self.amount, :post_type_id =>Post::DEBIT)
		when 2 # Purchase
			debit = Post.create(:trans=>trans, :account => self.order.vendor.cash_account, :value=>self.amount, :post_type_id =>Post::CREDIT)
			credit = Post.create(:trans=>trans, :account => self.order.client.cash_account, :value=>self.amount, :post_type_id =>Post::DEBIT)
		end
	end
	def amount
		return (self.presented||0)-(self.returned||0)
	end
#	def self.all_today()
#  	find 		 :all,
#		         :conditions => 'date(payments.created_at) = curdate()',
#		         :order => 'payments.created_at'
#	end
	def self.search(search, page, from=Date.today, till=Date.today, sites=[User.current_user.location_id])
		site_string=''
		for site in sites
			site_string+= ' OR 'if site_string !=''
			site_string+=' orders.vendor_id=' + site.to_s
		end
  	paginate :per_page => 20, :page => page,
		         :conditions => ['date(payments.created_at) >=:from AND date(payments.created_at) <= :till AND (payments.order_id like :search OR payments.order_id like :search OR payment_methods.name like :search ) AND ('+site_string+')', {:from=>from.to_date.to_s('%Y-%m-%d'), :till=>till.to_date.to_s('%Y-%m-%d'), :search => "%#{search}%"}],
		         :order => 'orders.receipt_number',
		         :joins => 'inner join orders on orders.id = payments.order_id inner join payment_methods on payment_methods.id = payments.payment_method_id inner join users on payments.user_id=users.id '

#  	paginate :per_page => 20, :page => page,
#		         :conditions => ['date(payments.created_at) >=:from AND date(payments.created_at) <= :till AND (order_id like :search OR payments.order_id like :search OR payment_methods.name like :search ) AND users.location_id=:site_id', {:from=>from.to_date.to_s('%Y-%m-%d'), :till=>till.to_date.to_s('%Y-%m-%d'), :site_id=>User.current_user.location_id,:search => "%#{search}%"}],
#		         :order => 'payments.created_at',
#		         :joins => 'inner join orders on orders.id = payments.order_id inner join payment_methods on payment_methods.id = payments.payment_method_id inner join users on payments.user_id=users.id'
	end
	def self.search_wo_pagination(search, from=Date.today, till=Date.today, sites=[User.current_user.location_id])
		site_string=''
		for site in sites
			site_string+= ' OR 'if site_string !=''
			site_string+=' orders.vendor_id=' + site.to_s
		end
  	find :all,
		         :conditions => ['date(payments.created_at) >=:from AND date(payments.created_at) <= :till AND (payments.order_id like :search OR payments.order_id like :search OR payment_methods.name like :search ) AND ('+site_string+')', {:from=>from.to_date.to_s('%Y-%m-%d'), :till=>till.to_date.to_s('%Y-%m-%d'), :search => "%#{search}%"}],
		         :order => 'orders.receipt_number',
		         :joins => 'inner join orders on orders.id = payments.order_id inner join payment_methods on payment_methods.id = payments.payment_method_id inner join users on payments.user_id=users.id'
#  	find :all,
#		         :conditions => ['date(payments.created_at) >=:from AND date(payments.created_at) <= :till AND (order_id like :search OR payments.order_id like :search OR payment_methods.name like :search ) AND users.location_id=:site_id', {:from=>from.to_date.to_s('%Y-%m-%d'), :till=>till.to_date.to_s('%Y-%m-%d'), :site_id=>User.current_user.location_id,:search => "%#{search}%"}],
#		         :order => 'payments.created_at',
#		         :joins => 'inner join orders on orders.id = payments.order_id inner join payment_methods on payment_methods.id = payments.payment_method_id inner join users on payments.user_id=users.id'
	end
end
