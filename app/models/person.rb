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

class Person < ActiveRecord::Base
	has_one :entity
	belongs_to :state
	def strip(s, c)
   clean=''
   s.each_char do |l|
		 if !c.include?(l)
		 	clean << l
		 end
   end
   return clean; 
  end
	def home_phone_number
  	if self.home_phone
			if self.home_phone.length == 8
				return self.home_phone[0..3] + "-" + self.home_phone[4..7]
			end
		end
  end
  def home_phone_number=(number)
  	self.home_phone=strip(number, ['-',' '])
  end
  def office_phone_number
  	if self.office_phone
			if self.office_phone.length == 8
				return self.office_phone[0..3] + "-" + self.office_phone[4..7]
			end
		end
  end
  def office_phone_number=(number)
  	self.office_phone=strip(number, ['-',' '])
  end
  def cell_phone_number
	  if self.cell_phone
			if self.cell_phone.length == 8
				return self.cell_phone[0..3] + "-" + self.cell_phone[4..7]
			end
		end
  end
  def cell_phone_number=(number)
  	self.cell_phone=strip(number, ['-',' '])
  end
  def nit_number
  	if self.nit
			if self.nit.length == 14
				return self.nit[0..3] + "-" + self.nit[4..9] + "-" + self.nit[10..12] + "-" + self.nit[13].to_s
			end
		end
  end
  def nit_number=(number)
  	self.nit=strip(number, ['-',' '])
  end
end

