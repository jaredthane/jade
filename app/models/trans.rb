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
	CONTRACT = 1
	INVENTORY = 2
	MONEY = 3
  has_many :posts, :dependent => :destroy
  has_many :entities , :through => :posts
	belongs_to :order
	belongs_to :payment
	belongs_to :user
	
	before_create :prepare_for_create
	def prepare_for_create
		# Make value positive if its negative
		if (self.posts[0].value || 0 ) < 0
			for p in self.posts
				p.value = (p.value || 0 ) * -1
				p.post_type_id = p.post_type_id * -1
			end
			self.direction = self.direction*-1
		end
	end
	def validate
		if posts.inject(0) { |result, element| result + element.value*element.post_type_id } != 0
			errors.add "Transaccion"," no cuadra"
			logger.debug "TRANSACTION REJECTED CAUSE ITS NOT BALANCED"
		end
	end
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
			logger.debug "saving posts!"
		for p in self.posts
			logger.debug "p(not saved)=#{p.inspect}"
			if p.account
				p.trans_id=self.id
				p.save
				p.errors.each {|e| puts "POst ERROR" + e.to_s}
				logger.debug "p(saved)=#{p.inspect}"
			end
		end
	end
	def post_by_account_id(id)
		for post in posts
			return post if post.account_id==id
		end
	end
	def self.search(search, page=nil)
		c = "description like '%#{search}%' OR accounts.name like '%#{search}%'"
		if search.to_s !=''
			c+=" OR trans.id = #{search} OR account_id = #{search}"
		end
		o = 'created_at'
		j='inner join posts on trans_id=trans.id inner join accounts on account_id=accounts.id'
		if page
  		paginate :per_page => 20, :page => page, :conditions => c, :order => o, :joins=>j, :group=>'trans.id'
  	else
  		find :all, :conditions => c, :order => o, :joins=>j, :group=>'trans.id'
  	end
	end
end
