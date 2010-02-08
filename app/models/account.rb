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
	def self.check
		sql = ActiveRecord::Base.connection()
		query='select sum(value*post_type_id) sum from posts'
		return sql.execute(query).fetch_hash["sum"].to_f
	end
	
	def self.thourough_check
		sql = ActiveRecord::Base.connection()
		query='select count(id) count from (select trans.id, sum(value*post_type_id) sum from posts inner join trans on trans.id=posts.trans_id group by trans.id) as trans where sum!=0'
		return sql.execute(query).fetch_hash["count"].to_f
	end
	def to_param
    "#{id}-#{name.parameterize}"
  end
	belongs_to :parent, :class_name => "Account", :foreign_key => "parent_id"
	belongs_to :entity
	has_many :posts, :dependent => :destroy
	has_many :trans, :through => :posts, :dependent => :destroy
	CREDIT = -1
	DEBIT = 1
	def number_and_name
		if self.number!=''
			return (self.number||'') + " - " + (self.name||'')
		else
			return (self.name||'')
		end
	end
	def self.find_by_name_or_create(arg)
		find_by_name(arg[:name]) || create(arg)
	end
	def self.search(search, filter = '', page=nil)
		c = "(accounts.name like '%#{search}%')"
		o = 'accounts.number'
		case filter
		when 'parent'
			c += ' AND is_parent=1'
		when 'child'
			c += ' AND is_parent=0'
		end
		if page
  		paginate :per_page => 20, :page => page, :conditions => c, :order => o
  	else
  		find :all, :conditions => c, :order => o
  	end
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
	def recent_posts(num=20)
		return Post.find_all_by_account_id(self.id, :order=>'created_at DESC', :limit=>num)
	end
	def all_posts
	  list = self.posts
    for child in children
  	    list += child.all_posts
  	end
	  return list
	end
	def balance
		if is_parent
			list = all_children.collect{|c| c.id.to_s + ", "}.to_s.chop.chop
			if list.length > 0
				sql = ActiveRecord::Base.connection()
				query = "select sum(value*post_type_id) total from posts where account_id in (#{list})"
				results = sql.execute(query).fetch_hash
				return results["total"].to_i * self.modifier
			else
				return 0
			end
		else
			sql = ActiveRecord::Base.connection()
			query = "select sum(value*post_type_id) total from posts where account_id = #{self.id.to_s}"
			results = sql.execute(query).fetch_hash
			return results["total"].to_i * self.modifier
		end
	end
  def validate
    errors.add "Nombre","no es válido" if !name or name==''
    if self.new_record?
    	errors.add "Nombre ","debe ser único" if Account.find(:first,:conditions=> "name = '#{name}'")
    end
  end
#	def parent_name
# 		parent.name if parent
#	end
#	def parent_name=(name)
#		self.parent = Account.find_or_create_by_name(name) unless name.blank?
#	end
	def transfer_balance_to(account)
		trans = Trans.create(:created_at=>User.current_user.today)
		amt=self.balance
		if account.modifier==1 and self.modifier==1
			act1 = Post.create(:trans=>trans, :account => self, :value=>amt, :post_type_id =>Post::CREDIT)
			act2 = Post.create(:trans=>trans, :account => account, :value=>amt, :post_type_id =>Post::DEBIT)
		elsif account.modifier==-1 and self.modifier==-1
			act1 = Post.create(:trans=>trans, :account => self, :value=>amt, :post_type_id =>Post::DEBIT)
			act2 = Post.create(:trans=>trans, :account => account, :value=>amt, :post_type_id =>Post::CREDIT)
		end
	end
	def recount_balances()
		balance=0
		for post in Post.find_all_by_account_id(self.id, :order => 'created_at')
			balance += ((post.value || 0)* (post.post_type_id || 0) * (post.account.modifier || 0))
			post.balance = balance
			post.save
		end
	end
end
