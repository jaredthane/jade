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

class Post < ActiveRecord::Base
  belongs_to :post_type
  belongs_to :trans
	belongs_to :account
#	has_many :entries, :order => "created_at DESC", :dependent => :destroy
	
	CREDIT = -1
	DEBIT = 1
	
	before_create :prepare_for_create
	def prepare_for_create
		#Set created_at to match the Trans
		logger.debug "Set created_at to match the Trans"
		self.created_at=trans.created_at if trans
		# Calculate balance
		calculate_balance
	end
	
	before_destroy :prepare_for_destroy
	def prepare_for_destroy
#		recalculate_later_balances(delete=true)
	end
	
	def calculate_balance
		if self.account
	    mydate=(self.created_at||Time.now)
		  last_post=Post.last(:conditions=> ['date(created_at) < :mydate AND account_id=:account', {:mydate=>mydate.to_s(:db), :account=>self.account_id}])
		  last_balace = last_post ? (last_post.balance || 0 ) : 0
		  change = (self.value || 0) * (self.post_type_id || 0) * (self.account.modifier || 0)
		  self.balance = last_balace + change
			self.account.balance = (self.account.balance || 0) + change
			self.account.save
			sql = ActiveRecord::Base.connection()
			query = "UPDATE posts set balance = balance + #{change} where account_id = #{self.account_id} and created_at > '#{mydate.to_s(:db)}'"
			results = sql.update(query)
		end
	end
	def self.search(kind=nil, from=nil, till=nil, page=nil, sites=[User.current_user.location_id])
	  sites=[User.current_user.location_id] if !sites

		ssites="(" + sites.collect{|a| a.to_s + ", "}.to_s.chop.chop + ")"
		c = "trans.direction=posts.post_type_id AND order_type_id=1"
		c += " AND kind_id=#{kind}" if kind
		c += " AND (orders.vendor_id in #{ssites} or orders.client_id in #{ssites})"
		c += " AND posts.created_at >= '#{from.to_s(:db)}'" if from
		c += " AND posts.created_at <= '#{(till + 1).to_s(:db)}'" if till
		j =  "inner join trans on posts.trans_id=trans.id"
		j += " inner join orders on orders.id=trans.order_id"
		g = "group by"
		s="posts.*, SUM(posts.value*posts.post_type_id) as sum"
		if page
		  paginate :per_page => 20, :page => page, :conditions => c, :order => 'receipt_number', :joins => j, :select => s, :group => "order_id"
		else
		  find :all, :conditions =>c, :joins => j, :order=> 'receipt_number', :select => s, :group => "order_id"
		end
	end

end
