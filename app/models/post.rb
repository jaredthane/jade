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
	before_destroy :prepare_for_destroy
	
	CREDIT = -1
	DEBIT = 1
	
	before_create :prepare_for_create
	def prepare_for_create
		# Make value positive if its negative
		logger.debug "making sure value is positive"
		self.value = (self.value || 0 ) * -1 if (self.value || 0 ) < 0
		# Calculate Balance
		logger.debug "Calculate Balance"
		calculate_balance
		#Set created_at to match the Trans
		logger.debug "Set created_at to match the Trans"
		self.created_at=trans.created_at if trans
		# If we're adding this post in the middle of the pile,
		# We need to update the balance of all posts that happened after this new one.
		logger.debug "checking for old posts"
		if self.created_at
			logger.debug "this is a new post and created at is pre-set"
			recalculate_later_balances
		end
	end
	def prepare_for_destroy
		recalculate_later_balances(delete=true)
	end
	def opposite_type
		return -1 if post_type==1
		return 1
	end
	##################################################################################################
	# Recalculates balances of all older posts
	# Default is to prepare for a create
	#################################################################################################	
	def recalculate_later_balances(delete=false)
		if delete 
			mod=-1 
		else
			mod=1
		end
		if self.account
			# *************** THIS SHOULD BE CHANGED TO A MYSQL UPDATE QUERY *******************************
			for post in Post.find(:all, :conditions=> "account_id= " + self.account_id.to_s + " AND created_at>'" + self.trans.created_at.to_s(:db) + "'")
				logger.debug 'POST WAS=' +post.value.to_s + ' * POST_TYPE=' + post.post_type_id.to_s + ' * MODIFIER='+post.account.modifier.to_s + '(BALANCE=' + post.balance.to_s + ')'
				post.balance=post.balance + (self.value || 0) * (self.post_type_id || 0) * (self.account.modifier || 0) * mod
				logger.debug 'New POST=' + post.value.to_s + ' * POST_TYPE=' + post.post_type_id.to_s + ' * MODIFIER='+post.account.modifier.to_s + '(BALANCE=' + post.balance.to_s + ')'
				post.save
			end
		end
	end

	##################################################################################################
	# Calculates balance based on accounts current balance + this posts value
	#################################################################################################	
	def calculate_balance
		# Now calculate the balance
		mydate=(self.created_at||Time.now)
#		logger.debug 'OLD BALANCE=' + self.account.simple_balance.to_s + '+ VALUE=' +self.value.to_s + ' * POST_TYPE=' + self.post_type_id.to_s + ' * MODIFIER='+self.account.modifier.to_s
		last_post=Post.last(:conditions=> ['date(trans.created_at) < :mydate AND posts.account_id=:account', {:mydate=>mydate.to_date.to_s('%Y-%m-%d'), :account=>self.account_id}],:joins=>'inner join trans on trans.id=posts.trans_id')
		if self.account
			if last_post
				self.balance=(last_post.balance || 0 ) + (self.value || 0) * (self.post_type_id || 0) * (self.account.modifier || 0)
			else
				self.balance=(self.value || 0) * (self.post_type_id || 0) * (self.account.modifier || 0)
			end
		end
	end
end
