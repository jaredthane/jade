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

class SerializedProduct < ActiveRecord::Base
	has_many :lines, :dependent => :destroy
	has_many :movements, :dependent => :destroy
	belongs_to :product
	def location
#		logger.debug "=-=======================================-="
		last_movement = self.movements.find(:last, :order=> 'id ASC')
		logger.debug "Last movement for " + self.product.name + "-" + self.serial_number + ":" + last_movement.inspect
		if last_movement
			return last_movement.entity
		else
			return nil
		end
	end
#	def location
#		if self.lines.find(:last, :order=> 'received')
#			return self.lines.find(:last, :order=> 'received').order.client
#		else
#			return nil
#		end
#	end
	def self.search(search, page)
  	paginate :per_page => 20, :page => page,
		         :conditions => ['(serial_number like :search OR upc like :search OR name like :search)', {:search => "%#{search}%"}],
		         :order => 'serial_number',
		         :joins => 'left join products on products.id = serialized_products.product_id'
	end
end
