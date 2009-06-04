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
	before_save :calculate_balance
	
	CREDIT = -1
	DEBIT = 1
	def opposite_type
		return -1 if post_type==1
		return 1
	end
	def calculate_balance
		# Make value positive if its negative
		self.value = (self.value || 0 ) * -1 if (self.value || 0 ) < 0
		# Now calculate the balance
		logger.info 'OLD BALANCE=' + self.account.simple_balance.to_s + '+ VALUE=' +self.value.to_s + ' * POST_TYPE=' + self.post_type_id.to_s + ' * MODIFIER='+self.account.modifier.to_s
		self.balance=(self.account.simple_balance || 0 ) + (self.value || 0) * (self.post_type_id || 0) * (self.account.modifier || 0)
	end
end
