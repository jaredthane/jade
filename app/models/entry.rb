# Jade Inventory Control System
#Copyright (C) 2009  Jared T. Martin

#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your oentryion) any later version.

#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.

#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

class Entry < ActiveRecord::Base
	belongs_to :post
	belongs_to :account
	
	before_destroy :prepare_for_destroy
	def prepare_for_destroy
		recalculate_later_balances(delete=true)
	end
	
	before_create :prepare_for_create
	def prepare_for_create
		# Calculate Balance
		#logger.debug "Calculate Balance"
		calculate_balance
		# If we're adding this post in the middle of the pile,
		# We need to update the balance of all posts that happened after this new one.
		#logger.debug "checking for old posts"
#		if self.created_at.to_date!=Date.today
#			logger.debug "this is a new post and created at is pre-set********************************************************"
#			recalculate_later_balances
#		else
#		  puts "We saved time!!*************************************************************"
#		end
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
			for entry in Entry.find(:all, :conditions=> "account_id= " + self.account_id.to_s + " AND created_at>'" + self.post.trans.created_at.to_s(:db) + "'")
#				#logger.debug 'POST WAS=' +entry.value.to_s + ' * POST_TYPE=' + entry.post_type_id.to_s + ' * MODIFIER='+entry.account.modifier.to_s + '(BALANCE=' + entry.balance.to_s + ')'
				entry.balance=(entry.balance||0) + (self.post.value || 0) * (self.post.post_type_id || 0) * (self.account.modifier || 0) * mod
#				#logger.debug 'New POST=' + entry.value.to_s + ' * POST_TYPE=' + entry.post_type_id.to_s + ' * MODIFIER='+entry.account.modifier.to_s + '(BALANCE=' + entry.balance.to_s + ')'
				entry.save
			end
		end
	end
	##################################################################################################
	# Calculates balance based on accounts current balance + this posts value
	#################################################################################################	
	def calculate_balance
		# Now calculate the balance
		#logger.debug 'OLD BALANCE=' + self.account.balance.to_s + '+ VALUE=' +self.post.value.to_s + ' * POST_TYPE=' + self.post.post_type_id.to_s + ' * MODIFIER='+self.account.modifier.to_s
		if self.account
			#logger.debug "Goot"
#			if self.created_at.to_date==Date.today
		    self.balance=(self.account.balance || 0 ) + (self.post.value || 0) * (self.post.post_type_id || 0) * (self.account.modifier || 0)
#		    puts "We saved more tiome!**************************"
#		    puts "self.id=" + self.id.to_s
#		    puts "self.created_at.to_date=" + self.created_at.to_date.to_s
		  else
#		    puts "We didnt save more tiome :(  **************************"
#		    puts "self.id=" + self.id.to_s
#		    puts "self.created_at.to_date=" + self.created_at.to_date.to_s

		    mydate=(self.created_at||Time.now)
			  last_entry=Entry.last(:conditions=> ['date(created_at) < :mydate AND account_id=:account', {:mydate=>mydate.to_s(:db), :account=>self.account_id}])
			  if last_entry
			  #logger.debug "Gooter"
				  self.balance=(last_entry.balance || 0 ) + (self.post.value || 0) * (self.post.post_type_id || 0) * (self.account.modifier || 0)
			  else
				  self.balance=(self.post.value || 0) * (self.post.post_type_id || 0) * (self.account.modifier || 0)
			  end
			end
			if self.account.balance
  			self.account.balance += (self.post.value || 0) * (self.post.post_type_id || 0) * (self.account.modifier || 0)
  		else
  		  self.account.balance = (self.post.value || 0) * (self.post.post_type_id || 0) * (self.account.modifier || 0)
  		end
		end
	end
end
