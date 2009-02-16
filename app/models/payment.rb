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

class Payment < ActiveRecord::Base
	belongs_to :order
	belongs_to :payment_method
	belongs_to :user
	belongs_to :receipt
	def amount
		return (self.presented||0)-(self.returned||0)
	end
	def self.search(search, page)
  	paginate :per_page => 20, :page => page,
		         :conditions => ['(payments.order_id like :search OR payment_methods.name like :search )', {:search => "%#{search}%"}],
		         :order => 'payments.created_at',
		         :joins => 'inner join orders on orders.id = payments.order_id inner join payment_methods on payment_methods.id = payments.payment_method_id'
	end
end
