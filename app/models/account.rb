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
	def all_posts
	  list = self.posts
    for child in children
  	    list += child.all_posts
  	end
	  return list
	end
	def balance
	  total=0
  	total += posts.last.balance if posts.length > 0
  	for child in children
  	  total += child.balance
  	end
  	return total
	end
end
