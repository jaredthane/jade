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

class Account < ActiveRecord::Base
  def to_param
    "#{id}-#{name.parameterize}"
  end
	belongs_to :parent, :class_name => "Account", :foreign_key => "parent_id"
	belongs_to :entity
	has_many :posts
	has_many :entries, :order => "created_at DESC"
	has_many :trans, :through => :posts
	CREDIT = -1
	DEBIT = 1
	def number_and_name
		if self.number!=''
			return (self.number||'') + " - " + (self.name||'')
		else
			return (self.name||'')
		end
	end
	def self.search(search, page)
  	paginate :per_page => 20, :page => page,
		         :conditions => ['(accounts.name like :search)', {:search => "%#{search}%"}],
		         :order => 'accounts.number'
	end
	def children
	  return Account.find_all_by_parent_id(self.id)
	end	
	def all_children
		list=Account.find_all_by_parent_id(self.id)
	  for child in list
	  	list +=child.all_children
	  end
	  return list
	end
	def all_entries
	  return self.entries
	end
	def recent_entries(limit)
	  return self.entries.find(:all, :order=>'created_at DESC',:limit=>limit)
	end
	
#	def all_posts
#	  list = self.posts
#    for child in children
#  	    list += child.all_posts
#  	end
#	  return list
#	end
	def balance
		last=entries.find(:last, :order=>'created_at')
		return last.balance if last 
	  return 0
	end
  def validate
  	logger.debug "HERE in validate++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    errors.add "Nombre","no es válido" if !name or name==''
    if self.new_record?
    	errors.add "Nombre ","debe ser único" if Account.find(:first,:conditions=> "name = '#{name}'")
    end
  end  
	def parent_name
 		parent.name if parent
	end
	def parent_name=(name)
		self.parent = Account.find_or_create_by_name(name) unless name.blank?
	end
	def transfer_balance_to(account)
		trans = Trans.create(:created_at=>User.current_user.today)
		amt=self.balance
		#puts "amt="+amt.to_s
		if account.modifier==1 and self.modifier==1
			act1 = Post.create(:trans=>trans, :account => self, :value=>amt, :post_type_id =>Post::CREDIT)
			act2 = Post.create(:trans=>trans, :account => account, :value=>amt, :post_type_id =>Post::DEBIT)
		elsif account.modifier==-1 and self.modifier==-1
			act1 = Post.create(:trans=>trans, :account => self, :value=>amt, :post_type_id =>Post::DEBIT)
			act2 = Post.create(:trans=>trans, :account => account, :value=>amt, :post_type_id =>Post::CREDIT)		
		end
	end
	def recount_balances()
#		balance=Post.last(:conditions=> ['date(trans.created_at) < :start AND posts.account_id=:account', {:start=>start.to_date.to_s('%Y-%m-%d'), :account=>self.id}],:joins=>'inner join trans on trans.id=posts.trans_id').balance
		balance=0
		for entry in Entry.find_all_by_account_id(self.id, :order => 'created_at')
			logger.debug "HELLO!!!!"
			logger.debug "entry.post.trans_id=#{entry.post.trans_id.to_s}"
			logger.debug "Balance:#{balance}+ post.value:#{(entry.post.value || 0)} * post_type_id:#{(entry.post.post_type_id || 0)} * account.modifier:#{(entry.account.modifier || 0)}"
			logger.debug "(entry.post.value || 0)* (entry.post.post_type_id || 0) * (entry.account.modifier || 0)=#{((entry.post.value || 0)* (entry.post.post_type_id || 0) * (entry.account.modifier || 0)).to_s}"
			balance += ((entry.post.value || 0)* (entry.post.post_type_id || 0) * (entry.account.modifier || 0))
			logger.debug "balance + ((entry.post.value || 0)* (entry.post.post_type_id || 0) * (entry.account.modifier || 0))=#{(balance + ((entry.post.value || 0)* (entry.post.post_type_id || 0) * (entry.account.modifier || 0))).to_s}"
			logger.debug "balance=#{balance.to_s}"
			entry.balance = balance
			entry.save
		end
	end
end
