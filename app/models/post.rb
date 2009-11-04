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
	has_many :entries, :order => "created_at DESC", :dependent => :destroy
	
	CREDIT = -1
	DEBIT = 1
	
	before_create :prepare_for_create
	def prepare_for_create
		# Make value positive if its negative
		logger.debug "making sure value is positive"
		self.value = (self.value || 0 ) * -1 if (self.value || 0 ) < 0
		#Set created_at to match the Trans
		logger.debug "Set created_at to match the Trans"
		self.created_at=trans.created_at if trans
	end
	after_create :create_entries
	def create_entries
		next_account = self.account
		while next_account
			Entry.create(:post=>self, :account=>next_account,:created_at=>self.created_at)
			next_account = next_account.parent
		end
	end
	def opposite_type
		return -1 if post_type==1
		return 1
	end
end
