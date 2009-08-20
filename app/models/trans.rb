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
  has_many :posts
  has_many :entities , :through => :posts
	belongs_to :order
	belongs_to :user
	after_save :save_posts
	def add_posts(posts)
		for post in posts
			p=Post.new(post)
			self.posts << p
		end
	end
	def save_posts
		#need to make sure they are balanced
		# and that no account is repeated
		for p in self.posts
			p.trans_id=self.id
			p.save
			p.errors.each {|e| puts "POst ERROR" + e.to_s}
		end
	end
	def post_by_account_id(id)
		for post in posts
			return post if post.account_id==id
		end
	end
end
