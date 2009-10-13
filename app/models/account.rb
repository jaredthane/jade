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
	belongs_to :parent, :class_name => "Account", :foreign_key => "parent_id"
	belongs_to :entity
	has_many :posts
	has_many :trans, :through => :posts
	CREDIT = -1
	DEBIT = 1
	
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
	def all_posts
	  c = 'account_id=' + self.id.to_s
    for child in all_children
    	c += ' OR account_id=' + child.id.to_s
    end
    list=Post.find(:all, :conditions=>c, :order=>'id DESC')
	  return list
	end
	def recent_posts(limit)
	  c = 'account_id=' + self.id.to_s
    for child in all_children
    	c += ' OR account_id=' + child.id.to_s
    end
    list=Post.find(:all, :conditions=>c, :order=>'id DESC',:limit=>limit)
	  return list
	end
	
#	def all_posts
#	  list = self.posts
#    for child in children
#  	    list += child.all_posts
#  	end
#	  return list
#	end
	def balance
	  total=0
  	total += simple_balance
  	for child in children
  	  total += child.balance
  	end
  	return total
	end
	def simple_balance
		last=posts.find(:last, :order=>'created_at')
	  if last
	  	return last.balance
	  else
	  	return 0
  	end
	end
	def transfer_balance_to(account)
		trans = Trans.create(:created_at=>User.current_user.today)
		amt=posts.last.balance
		puts "amt="+amt.to_s
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
		for post in Post.find(:all, :conditions=>'account_id='+self.id.to_s, :order=>'created_at')
			post.balance=balance+(post.value || 0)* (post.post_type_id || 0) * (post.account.modifier || 0)
			balance=post.balance
			post.save
		end
	end
end
