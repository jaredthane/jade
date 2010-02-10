# Jade Inventory Control System
# Copyright (C) 2009  Jared T. Martin

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
class BaseContract < ActiveRecord::Base
	belongs_to :site
	has_many :base_lines
	belongs_to :completer, :class_name => "User", :foreign_key => 'completed_by'
	belongs_to :blocker, :class_name => "User", :foreign_key => 'blocked_by'
	belongs_to :creator, :class_name => "User", :foreign_key => 'created_by'
	belongs_to :updater, :class_name => "User", :foreign_key => 'updated_by'
	belongs_to :deleter, :class_name => "User", :foreign_key => 'deleted_by'

	#################################################################################################
	# Sets total to total of all lines including taxes where aplicable
	# Checks for Discounts
	# Creates Movements
	# Sets Received if all lines have been received
	#################################################################################################
	before_save :pre_save
  def pre_save
    if self.deleted
      self.total = 0
    else
  	  self.total = self.total_price_with_tax
  	end
	#	  check_for_discounts
	#	  split_over_sized_order
	#	  m = main_transaction
	#	  i = inventory_transaction
	#	  self.transactions << m if m
	#	  self.transactions << i if i
	#	  self.received=last_received
  end
  ###################################################################################
	# Returns the total price of all of the lines on the order, not including tax
	###################################################################################
	def total_price
		return self.lines.inject(0) { |result, element| result + (element.total_price||0) }
	end
  ###################################################################################
	# Returns the total cost of all of the products in the order
	###################################################################################
	def total_cost
		return self.lines.inject(0) { |result, element| result + (element.total_cost||0) }
	end
	###################################################################################
	# Returns the total tax to be charged the user.
	###################################################################################
	def total_tax
		return 0 if !client
		return 0 if client.entity_type_id == 2
		return self.lines.inject(0) { |result, element| result + (element.total_tax||0) }
	end
	###################################################################################
	# Returns the total price of all of the products in the order plus tax
	###################################################################################
	def total_price_with_tax
		return self.lines.inject(0) { |result, element| result + (element.total_price_with_tax||0) }
	end
end
