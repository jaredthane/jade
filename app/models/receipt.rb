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

class Receipt < ActiveRecord::Base
	belongs_to :user
	belongs_to :order
	has_many :lines
	###################################################################################
	# Returns the total price of all of the products requested, not including tax
	###################################################################################
	def total_price
		total=0
		for l in self.lines
			total = (total||0) + (l.total_price||0)
		end
		return (total||0)
	end
  ###################################################################################
	# Returns the total cost of all of the products requested
	###################################################################################
	def total_cost
		total=0
		for l in self.lines
			total = (total||0) + (l.total_cost||0)
		end
		return (total||0)
	end
	###################################################################################
	# Returns the total tax to be charged the user.
	###################################################################################
	def total_tax
		total=0
		for l in self.lines
			total = (total||0) + (l.tax||0)
		end
		return (total||0)
	end
	
	###################################################################################
	# Returns the total price of all of the products requested plus tax
	###################################################################################
	def total_price_with_tax
		total=0
		if order.client
			if order.client.entity_type_id == 2
				for l in self.lines
					total = (total||0) + (l.total_price||0)
				end
			else
				for l in self.lines
					total = (total||0) + (l.total_price_with_tax||0)
				end
			end
		else
			for l in self.lines
				total = (total||0) + (l.total_price||0)
			end
		end
		return (total||0)
	end
	def tens_to_spanish(num)
#		# puts "received:" + num.to_s
		case num
			when 20
#				# puts "returning veinte"
				return 'veinte'
			when 30
				return 'treinta'
			when 40
				return 'cuarenta'
			when 50
				return 'cincuenta'
			when 60
				return 'sesenta'
			when 70
				return 'setenta'
			when 80
				return 'ochenta'
			when 90
				return 'noventa'
			else
				return ''
		end
	end
	def hundreds_to_spanish(num)
		# handles only hundreds place
#		# puts "received:" + num.to_s
		case num
			when 100
				return 'ciento'
			when 200
				return 'doscientos'
			when 300
				return 'trescientos'
			when 400
				return 'cuatrocientos'
			when 500
				return 'quinientos'
			when 600
				return 'seiscientos'
			when 700
				return 'setecientos'
			when 800
				return 'ochocientos'
			when 900
				return 'novecientos'
			else
				return ''
		end
	end
	def number_to_spanish (num)
 		# depends on tens_to_spanish(num) and hundreds_to_spanish() and number_to_spanish() 
 		# to handle  numbers 0-999,999,999
		answer=""
		millions = digits_to_spanish((num/1000000).to_i)		
		thousands = digits_to_spanish((num/1000).to_i%1000)
		ones = digits_to_spanish((num%1000).to_i)
		cents = digits_to_spanish((num*100).to_i%100)
		answer = millions + ' milliones,' if (num/1000000).to_i > 1
		answer = 'un million,' if (num/1000000).to_i == 1
		answer += ' ' if answer != '' and (num/1000).to_i%1000 > 0
		answer += thousands + ' mil,' if (num/1000).to_i%1000 > 0
		answer += ' ' if answer != '' and (num%1000).to_i > 0
		answer += ones + ' dolares' if (num%1000).to_i > 1
		answer += 'un dolar' if (num%1000).to_i == 1
		answer = 'cero dolares' if answer == '' or answer == nil
		answer += ' con un centavo' if (num*100).to_i%100 == 1
		answer += ' con '+ cents + ' centavos' if (num*100).to_i%100 > 1
		return answer
	end
	def digits_to_spanish(num)
		if num == 100
			return 'cien'
		end
 		# depends on tens_to_spanish(num) and hundreds_to_spanish() to handle  numbers 1-999
		answer = hundreds_to_spanish((num/100).to_i%10*100)
		answer += ' ' if answer != '' and (num%100 > 0)
		answer += tens_to_spanish((num/10).to_i%10*10) if ((num%100).to_i > 19)
		answer += ' y ' if ((num/10).to_i%10*10 > 19) and (num%10 > 0)
		if (num%100).to_i < 20
			answer += ones_to_spanish((num%100).to_i)
		else
			answer += ones_to_spanish((num%10).to_i)
		end
		#answer = 'cero' if answer == ''
	end
	def ones_to_spanish (num)
	
		case num
			when 1
				return 'un'
			when 2
				return 'dos'
			when 3
				return 'tres'
			when 4
				return 'cuatro'
			when 5
				return 'cinco'
			when 6
				return 'seis'
			when 7
				return 'siete'
			when 8
				return 'ocho'
			when 9
				return 'nueve'
			when 10
				return 'diez'
			when 11
				return 'once'
			when 12
				return 'doce'
			when 13
				return 'trece'
			when 14
				return 'catorse'
			when 15
				return 'quince'
			when 16
				return 'dieciseis'
			when 17
				return 'dieciseite'
			when 18
				return 'dieciocho'
			when 19
				return 'diecinueve'
			else
				return ''
		end
	end
	###################################################################################
	# Returns the total price of all of the products requested with tax spelled out in spanish
	###################################################################################
	def total_price_with_tax_in_spanish
		return number_to_spanish(self.total_price_with_tax)
	end
#	def self.consumidor_final(page, from=Date.today, till=Date.today)
#  	paginate :per_page => 20, :page => page,
#		         :conditions => ['date(receipts.created_at) >=:from AND date(receipts.created_at) <= :till AND clients.entity_type_id=2 AND orders.vendor_id=:site_id',{:from=>from.to_date.to_s('%Y-%m-%d'), :till=>till.to_date.to_s('%Y-%m-%d'), :site_id=>User.current_user.location_id}],
#		         :order => 'receipts.id',
#		         :joins => 'inner join orders on orders.id=receipts.order_id inner join entities as clients on clients.id = orders.client_id'
#	end
#	def self.credito_fiscal(page, from=Date.today, till=Date.today)
#  	paginate :per_page => 20, :page => page,
#		         :conditions => ['date(receipts.created_at) >=:from AND date(receipts.created_at) <= :till AND clients.entity_type_id=5 AND orders.vendor_id=:site_id',{:from=>from.to_date.to_s('%Y-%m-%d'), :till=>till.to_date.to_s('%Y-%m-%d'), :site_id=>User.current_user.location_id}],
#		         :order => 'receipts.created_at',
#		         :joins => 'inner join orders on orders.id=receipts.order_id inner join entities as clients on clients.id = orders.client_id'
#	end
	def self.search_credito_fiscal(search, page, from=Date.today, till=Date.today, sites=[User.current_user.location_id])
		site_string=''
		for site in sites
			site_string+= ' OR 'if site_string !=''
			site_string+=' clients.site_id=' + site.to_s
		end
  	paginate :per_page => 20, :page => page,
		         :conditions => ['clients.entity_type_id=5 AND ((date(receipts.created_at) >=:from AND date(receipts.created_at) <= :till) OR (date(receipts.deleted) >=:from AND date(receipts.deleted) <= :till)) AND (orders.id like :search or vendors.name like :search or clients.name like :search) AND ('+site_string+')', {:from=>from.to_date.to_s('%Y-%m-%d'), :till=>till.to_date.to_s('%Y-%m-%d'),:search => "%#{search}%"}],
		         :order => 'receipts.number',
		         :joins => 'inner join orders on receipts.order_id = orders.id left join users on users.id=orders.user_id inner join entities as vendors on vendors.id = orders.vendor_id inner join entities as clients on clients.id = orders.client_id'
#  	paginate :per_page => 20, :page => page,
#		         :conditions => ['((date(receipts.created_at) >=:from AND date(receipts.created_at) <= :till) OR (date(receipts.deleted) >=:from AND date(receipts.deleted) <= :till)) AND clients.entity_type_id=5 AND (orders.id like :search or vendors.name like :search or clients.name like :search) AND users.location_id=:site_id', {:from=>from.to_date.to_s('%Y-%m-%d'), :till=>till.to_date.to_s('%Y-%m-%d'), :site_id=>User.current_user.location_id,:search => "%#{search}%"}],
#		         :order => 'receipts.id',
#		         :joins => 'inner join orders on receipts.order_id = orders.id left join users on users.id=orders.user_id inner join entities as vendors on vendors.id = orders.vendor_id inner join entities as clients on clients.id = orders.client_id'
	end
	def self.search_consumidor_final(search, page, from=Date.today, till=Date.today, sites=[User.current_user.location_id])
		site_string=''
		for site in sites
			site_string+= ' OR 'if site_string !=''
			site_string+=' clients.site_id=' + site.to_s
		end
  	paginate :per_page => 20, :page => page,
		         :conditions => ['clients.entity_type_id=2 AND ((date(receipts.created_at) >=:from AND date(receipts.created_at) <= :till) OR (date(receipts.deleted) >=:from AND date(receipts.deleted) <= :till)) AND (orders.id like :search or vendors.name like :search or clients.name like :search) AND ('+site_string+')', {:from=>from.to_date.to_s('%Y-%m-%d'), :till=>till.to_date.to_s('%Y-%m-%d'),:search => "%#{search}%"}],
		         :order => 'receipts.number',
		         :joins => 'inner join orders on receipts.order_id = orders.id left join users on users.id=orders.user_id inner join entities as vendors on vendors.id = orders.vendor_id inner join entities as clients on clients.id = orders.client_id'
#  	paginate :per_page => 20, :page => page,
#		         :conditions => ['((date(receipts.created_at) >=:from AND date(receipts.created_at) <= :till) OR (date(receipts.deleted) >=:from AND date(receipts.deleted) <= :till)) AND (orders.id like :search or vendors.name like :search or clients.name like :search) AND users.location_id=:site_id', {:from=>from.to_date.to_s('%Y-%m-%d'), :till=>till.to_date.to_s('%Y-%m-%d'), :site_id=>User.current_user.location_id,:search => "%#{search}%"}],
#		         :order => 'receipts.id',
#		         :joins => 'inner join orders on receipts.order_id = orders.id left join users on users.id=orders.user_id inner join entities as vendors on vendors.id = orders.vendor_id inner join entities as clients on clients.id = orders.client_id'
	end
#	def self.all(page, from=Date.today, till=Date.today)
#  	find 		 :all,
#		         :conditions => ['date(receipts.created_at) >=:from AND date(receipts.created_at) <= :till AND orders.vendor_id=:site_id',{:from=>from.to_date.to_s('%Y-%m-%d'), :till=>till.to_date.to_s('%Y-%m-%d'), :site_id=>User.current_user.location_id}],
#		         :order => 'receipts.number',
#		         :joins => 'inner join orders on orders.id=receipts.order_id'
#	end
	def self.search(search, page, from=Date.today, till=Date.today)
  	paginate :per_page => 20, :page => page,
		         :conditions => ['((date(receipts.created_at) >=:from AND date(receipts.created_at) <= :till) OR (date(receipts.deleted) >=:from AND date(receipts.deleted) <= :till)) AND (orders.id like :search or vendors.name like :search or clients.name like :search) AND users.location_id=:site_id', {:from=>from.to_date.to_s('%Y-%m-%d'), :till=>till.to_date.to_s('%Y-%m-%d'), :site_id=>User.current_user.location_id,:search => "%#{search}%"}],
		         :order => 'receipts.number',
		         :joins => 'inner join orders on receipts.order_id = orders.id left join users on users.id=orders.user_id inner join entities as vendors on vendors.id = orders.vendor_id inner join entities as clients on clients.id = orders.client_id'
	end
	def self.search_wo_pages(search, from=Date.today, till=Date.today, sites=[User.current_user.location_id])
		site_string=''
		for site in sites
			site_string+= ' OR 'if site_string !=''
			site_string+=' clients.site_id=' + site.to_s
		end
  	find :all,
		         :conditions => ['((date(receipts.created_at) >=:from AND date(receipts.created_at) <= :till) OR (date(receipts.deleted) >=:from AND date(receipts.deleted) <= :till)) AND (orders.id like :search or vendors.name like :search or clients.name like :search) AND ('+site_string+')', {:from=>from.to_date.to_s('%Y-%m-%d'), :till=>till.to_date.to_s('%Y-%m-%d'),:search => "%#{search}%"}],
		         :order => 'receipts.number',
		         :joins => 'inner join orders on receipts.order_id = orders.id left join users on users.id=orders.user_id inner join entities as vendors on vendors.id = orders.vendor_id inner join entities as clients on clients.id = orders.client_id'
#  	find :all,
#		         :conditions => ['((date(receipts.created_at) >=:from AND date(receipts.created_at) <= :till) OR (date(receipts.deleted) >=:from AND date(receipts.deleted) <= :till)) AND (orders.id like :search or vendors.name like :search or clients.name like :search) AND users.location_id=:site_id', {:from=>from.to_date.to_s('%Y-%m-%d'), :till=>till.to_date.to_s('%Y-%m-%d'), :site_id=>User.current_user.location_id,:search => "%#{search}%"}],
#		         :order => 'receipts.number',
#		         :joins => 'inner join orders on receipts.order_id = orders.id left join users on users.id=orders.user_id inner join entities as vendors on vendors.id = orders.vendor_id inner join entities as clients on clients.id = orders.client_id'
	end
	def self.search_unpaid(search, page)
  	paginate :per_page => 20, :page => page,
 						 :conditions => ['(amount_paid < grand_total) AND (order_type_id = 1) AND (clients.name like :search OR clients.id like :search) AND (vendors.id=:current_location OR clients.id=:current_location) AND (clients.id != 1)', {:search => "%#{search}%", :current_location => "#{User.current_user.location_id}"}],
		         :order => 'created_at',
						 :joins => "inner join orders on order_id=orders.id inner join entities as vendors on vendors.id = orders.vendor_id inner join entities as clients on clients.id = orders.client_id"
	end
end
