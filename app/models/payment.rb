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
	belongs_to :receipt
	before_save :prepare_transactions
	after_save :create_transactions
	attr_accessor :transactions_to_create
	def prepare_transactions
		if new_record?
			amt=self.amount
		else			
			amt = self.amount - old.amount
		end
		case order.order_type_id
		when 1 # Sale
			debit = Post.new(:account => self.order.cash_account, :value=>amt, :post_type_id =>Post::DEBIT)
			credit = Post.new(:account => self.order.client.cash_account, :value=>amt, :post_type_id =>Post::CREDIT)
			@transactions_to_create = [[debit, credit]]
		when 2 # Purchase
			debit = Post.new(:account => self.order.vendor.cash_account, :value=>amt, :post_type_id =>Post::DEBIT)
			credit = Post.new(:account => self.order.client.cash_account, :value=>amt, :post_type_id =>Post::CREDIT)
			@transactions_to_create = [[debit, credit]]
		end
	end
	def create_transactions
	  puts "create transactions -> @transactions_to_create = "+@transactions_to_create.to_s
	  @transactions_to_create = [] if !@transactions_to_create
	  for t in @transactions_to_create
	  	if self.order
		    trans = Trans.create(:order => self.order, :comments => self.order.comments)
		  else
		    trans = Trans.create()
		  end
	    for p in t
	      p.trans_id = trans.id
	      puts "create transactions -> p = "+p.inspect
	      puts "save result"+p.save.to_s
	      p.errors.each {|e| puts "POst ERROR" + e.to_s}
	    end
	  end
	end
	def amount
		return (self.presented||0)-(self.returned||0)
	end
	def self.search(search, page)
  	paginate :per_page => 20, :page => page,
		         :conditions => ['(payments.order_id like :search OR payment_methods.name like :search )', {:search => "%#{search}%"}],
		         :order => 'payments.created_at',
		         :joins => 'inner join orders on orders.id = payments.order_id inner join payment_methods on payment_methods.id = payments.payment_method_id'
	end
end
