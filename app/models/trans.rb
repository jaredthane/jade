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

class Trans < ActiveRecord::Base
	FORWARD = 1
	REVERSE = -1
	NEUTRAL = 0
  has_many :posts
  has_many :entities , :through => :posts
	belongs_to :order
	belongs_to :payment
	belongs_to :user
#	after_save :save_posts
	def add_posts(posts)
		for post in posts
			p=Post.new(post)
			self.posts << p
		end
	end
	def obj_link
	  if self.payment
	    return self.payment
	  else
	    return self.order
	  end	  
	end
	def save_posts
		#need to make sure they are balanced
		# and that no account is repeated
		for p in self.posts
			if p.account
				p.trans_id=self.id
				p.save
				p.errors.each {|e| puts "POst ERROR" + e.to_s}
			end
		end
	end
	def post_by_account_id(id)
		for post in posts
			return post if post.account_id==id
		end
	end
	def search(order_type_id=nil, from=nil, till=nil, page=nil)
		c = "order_type_id = #{order_type_id.to_s} "
		c += " AND created_at >= '#{from.to_s(:db)}'" if from
		c += " AND created_at <= '#{(till + 1).to_s(:db)}'" if till
		j = 'inner join orders on order.id=trans.order_id'
		
		
		
		j += 'inner join posts on posts.trans_id=trans.id'
		j += ' and direction=-1' if order_type_id == SALE
		j += ' and direction=1' if order_type_id == PURCHASE
		inner join posts on posts.account_id = accounts.id
		Trans.find()
		
	end
end
