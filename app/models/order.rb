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

class Order < ActiveRecord::Base
	has_many :lines, :dependent => :destroy
	has_many :products, :through => :lines
	has_many :payments
	has_many :movements
	HUMANIZED_ATTRIBUTES = {
    :user => "Usuario",
    :ordered => "Fecha de Solicitud",
    :vendor => "Proveedor",
    :client => "Cliente"
  }
  def self.human_attribute_name(attr)
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
  def validate
  	#puts "validating order"
  end
	after_update :save_lines
	after_create :create_lines
	belongs_to :vendor, :class_name => "Entity", :foreign_key => 'vendor_id'
	belongs_to :client, :class_name => "Entity", :foreign_key => 'client_id'
	validates_presence_of(:vendor, :message => "debe ser valido")
	validates_presence_of(:client, :message => "debe ser valido")
	validates_associated :lines
	belongs_to :user
	validates_presence_of(:user, :message => "debe ser valido")
	
	def get_discounts
  	product_type=ProductType.find(2)
    @discounts = product_type.products.find(:all, :order => "name")
  end
  def get_sum(product)
  	sum=0
  	o=Order.find(self.id)
  	#puts "num lines: " + o.lines.count.to_s
  	for line in o.lines
  		#puts "checking line#" + line.id.to_s
  		if line.product.id==product.id
  			#puts "found some"
  			sum+=line.quantity
  		end
  	end
  	return sum
  end
  def check_for_discounts
		for discount in get_discounts do #Go through each discount
			if discount.available
				@qualify=100
				for req in discount.requirements do        #Check if the order has enough of each product
					@wehave = get_sum(req.required)
					@weneed = req.quantity
					#puts "@wehave ->" + @wehave.to_s + "<-"
					if @wehave == nil
						#puts "@wehave is null again"
					end
					#puts "@weneed ->" + @weneed.to_s + "<-"
					@temp = @wehave / @weneed
					@qualify= [@qualify, @temp].min
				end #req in discount.requirements
				if @qualify >= 1			                     		#If the order qualifies,
					##puts "It Qualifies!!!!!!!!!!!!!!!!!!!"
					l=Line.new(:order_id => self.id, :product_id => discount.id, :quantity => @qualify, :price => discount.price, :received => 1)
					l.save
				end #if qualify==1
			end # if available
		end #discount in get_discounts
	end #check_for_discounts
	

	
	def total_price
		total=0
		for l in self.lines
			total = total + (l.total_price)
		end
		return total
	end
	def total_tax
		total=0
		for l in self.lines
			total = total + (l.tax)
		end
		return total
	end
	def total_price_with_tax
		total=0
		for l in self.lines
			total = total + (l.total_price_with_tax)
		end
		return total
	end
	def total_price_with_tax_in_spanish
		return number_to_spanish(self.total_price_with_tax)
	end
	def amount_paid
		return self.payments.sum(:amount, :conditions => ['order_id = :order_id', {:order_id => self.id}])
	end
	def vendor_name
		vendor.name if vendor
	end
	def vendor_name=(name)
		self.vendor = Entity.find_by_name(name) unless name.blank?
	end
	def client_name
		client.name if client
	end
	def client_name=(name)
		self.client = Entity.find_by_name(name) unless name.blank?
	end
	def user_name
		user.login if user
	end
	def user_name=(name)
		self.user = User.find_by_login(name) unless name.blank?
	end
	
	def order_type
		if self.client.id==1
			return 'internal'
		end
		if self.vendor.entity_type.id == 3 
			 if self.client.entity_type.id == 3 
				 'transfers' 
			 else 
				 'sales' 
			 end 
		else 
			 if self.client.entity_type.id == 3 
				 'purchases' 
			 else 
				 'other' 
			 end 
		 end
	end
	def save_lines
		lines.each do |line|
			line.save(false)
		end
	end
	def create_lines
		#puts "creating lines"
		lines.each do |line|
			#puts "setting order_id to " + self.id.to_s
			line.order_id = self.id 
			line.save(true)
		end		
	end
	def last_received
		##puts "Checking for order number "+self.id.to_s
		@received=nil
		for line in self.lines do
			return nil if line.received == nil
			if @received == nil
				@received=line.received
				##puts line.product.name + " was received " + line.received.to_s + " 2received set to "+@received.to_s
			else 
				if line.received > @received
					##puts line.product.name + " was received " + line.received.to_s + " received is already "+@received.to_s
					@received=line.received
					##puts line.product.name + " was received " + line.received.to_s + " 1received set to "+@received.to_s
				end
			end
		end
		return @received
	end
	def self.search(search, page)
		paginate :per_page => 20, :page => page,
						 :conditions => ['(vendors.name like :search OR clients.name like :search OR orders.id like :search) AND (vendors.id=:current_location OR clients.id=:current_location)', {:search => "%#{search}%", :current_location => "#{User.current_user.location_id}"}],
						 :order => 'created_at desc',
						 :joins => "inner join entities as vendors on vendors.id = orders.vendor_id inner join entities as clients on clients.id = orders.client_id"
	end
	def self.search_sales(search, page)
		paginate :per_page => 20, :page => page,
						 :conditions => ['(vendors.entity_type_id = 3 and clients.name like :search) AND (vendors.id=:current_location OR clients.id=:current_location) AND (clients.id != 1)', {:search => "%#{search}%", :current_location => "#{User.current_user.location_id}"}],
						 :order => 'created_at desc',
						 :joins => "inner join entities as vendors on vendors.id = orders.vendor_id inner join entities as clients on clients.id = orders.client_id"
	end
	def self.search_purchases(search, page)
		paginate :per_page => 20, :page => page,
						 :conditions => ['(vendors.name like :search and clients.entity_type_id = 3) AND (vendors.id=:current_location OR clients.id=:current_location)', {:search => "%#{search}%", :current_location => "#{User.current_user.location_id}"}],
						 :order => 'created_at desc',
						 :joins => "inner join entities as vendors on vendors.id = orders.vendor_id inner join entities as clients on clients.id = orders.client_id"
	end
	def self.search_internal(search, page)
		paginate :per_page => 20, :page => page,
						 :conditions => ['vendors.name like :search AND orders.client_id = 1 AND orders.vendor_id=:current_location', {:search => "%#{search}%", :current_location => "#{User.current_user.location_id}"}],
						 :order => 'created_at desc',
						 :joins => "inner join entities as vendors on vendors.id = orders.vendor_id"
	end
	def self.search_batch(search, page)
		paginate :per_page => 20, :page => page,
						 :conditions => ['(last_batch=True) AND (vendors.name like :search OR clients.name like :search OR orders.id like :search) AND (vendors.id=:current_location OR clients.id=:current_location)', {:search => "%#{search}%", :current_location => "#{User.current_user.location_id}"}],
						 :order => 'created_at desc',
						 :joins => "inner join entities as vendors on vendors.id = orders.vendor_id inner join entities as clients on clients.id = orders.client_id"
	end
	def tens_to_spanish(num)
#		puts "received:" + num.to_s
		case num
			when 20
#				puts "returning veinte"
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
#		puts "received:" + num.to_s
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
end
