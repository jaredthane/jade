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

class Product < ActiveRecord::Base

	HUMANIZED_ATTRIBUTES = {
    :unit => "Unidad",
    :upc => "UPC",
    :name => "Nombre"
  }

  def self.human_attribute_name(attr)
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
  has_many :prices
  has_many :warranties
  has_many :inventories
	has_many :lines
	belongs_to :product_category
	has_many :movements
	has_many :serialized_products
	has_many :requirements, :dependent => :destroy
	after_update :save_requirements
	after_update :update_cost
	after_create :update_cost
	after_create :create_requirements
	belongs_to :product_type
	belongs_to :unit
	belongs_to :vendor, :class_name => "Entity", :foreign_key => 'vendor_id'
	validates_presence_of(:vendor, :message => "debe ser valido")
	validates_presence_of(:unit, :message => "debe ser valido")
	validates_presence_of(:name, :message => "debe ser valido.")
	validates_uniqueness_of(:name, :message => "debe ser único.") 
	validates_uniqueness_of(:upc, :message => "debe ser único.") 

	def category_name
 		product_category.name if product_category
	end
	def category_name=(name)
		self.product_category = ProductCategory.find_or_create_by_name(name) unless name.blank?
	end
	def vendor_name
 		vendor.name if vendor
	end
	def vendor_name=(name)
		self.vendor = Entity.find_by_name(name) unless name.blank?
	end
	def require_lines
		combo_lines.find(:all, :conditions =>"combo_line_type_id == 1")
	end
	def give_lines
		combo_lines.find(:all, :conditions =>"combo_line_type_id == 2")
	end
	def calculate_quantity(location_id = User.current_user.location_id)
		i=self.inventories.find_by_entity_id(location_id)
		if self.product_type_id==1
			logger.debug "getting simple sum"
			i.quantity=self.movements.sum(:quantity)
		elsif self.product_type_id==3
			logger.debug "this is a combo"
			newquantity=nil
			for req in self.requirements
				if newquantity == nil
#					logger.debug "quantity=req.required.id=#{req.required.id.to_s}"
#					logger.debug "req.required.quantity(location_id)=#{req.required.quantity(location_id).to_s}"
#					logger.debug "req.quantity=#{req.quantity.to_s}"
#					logger.debug "(req.required.quantity(location_id) / req.quantity).to_i=#{(req.required.quantity(location_id) / req.quantity).to_i.to_s}"
					newquantity = (req.required.quantity(location_id) / req.quantity).to_i
				else
#					logger.debug "req.required.id=#{req.required.id.to_s}"
#					logger.debug "req.required.quantity(location_id)=#{req.required.quantity(location_id).to_s}"
#					logger.debug "req.quantity=#{req.quantity.to_s}"
#					logger.debug "[(req.required.quantity(location_id) / req.quantity).to_i, quantity].min =#{[(req.required.quantity(location_id) / req.quantity).to_i, quantity].min .to_s}"
					newquantity = [(req.required.quantity(location_id) / req.quantity).to_i, newquantity].min 
				end
			end
			logger.debug "quantity=#{quantity.to_s}"
			i.quantity = newquantity
		end
		i.save
		reqs=Requirement.find_all_by_required_id(self.id) #Update any combos I might be a member of
		if reqs
			for req in reqs
				req.product.calculate_quantity(location_id)
			end
		end
	end
	def update_cost(location_id = User.current_user.location_id)
	    # puts "Hello There <-------------------------------------------------------------"
	    # puts self.calculate_cost(location_id)
	    self.cost = self.calculate_cost(location_id)
	end
	def calculate_cost(location_id = User.current_user.location_id)
		logger.debug "product.id=#{self.id.to_s}"
		logger.debug "location_id=#{location_id.to_s}"
		moves=connection.select_all("select movements.* from (select max(movements.id) as id from movements where product_id=#{self.id.to_s} group by order_id order by id DESC) as list left join movements on list.id=movements.id where movement_type_id=2;")
		#moves = movements.find_all_by_entity_id(location_id, :order => 'created_at desc')
		logger.debug "self.quantity(location_id)=" + self.quantity(location_id).to_s
		# puts moves.inspect
		stock = self.quantity(location_id)
		logger.debug "stock" + stock.to_s
		logger.debug "moves.length=" + moves.length.to_s
		if (stock == 0) or (moves.length == 0)
		    return self.default_cost
		end
		items_to_count = stock
		totalcost=0
		for m in moves
		  take = [items_to_count, m["quantity"].to_i].min
		  totalcost += (m["value"].to_i || 0) /(m["quantity"].to_i || 0) * (take || 0)
		  items_to_count -= take
		  break if items_to_count < 1
		end
#		while	(moves[movement_counter]) do
#			logger.debug moves[movement_counter].inspect
#			logger.debug "stock" + stock.inspect
#			logger.debug "items_counted" + items_counted.inspect
#			## puts "moves[movement_counter].quantity" + moves[movement_counter].quantity
#			logger.debug "moves[movement_counter][quantity]" + moves[movement_counter]["quantity"].to_s
#			logger.debug "stock-items_counted" + (stock-items_counted).inspect
#			logger.debug "[stock-items_counted, moves[movement_counter].quantity].min=" + [stock-items_counted, moves[movement_counter]["quantity"].to_i].min.inspect
#      logger.debug "id:"+moves[movement_counter]["id"].to_s
#			logger.debug moves[movement_counter]["quantity"].to_i
#			logger.debug stock
#			logger.debug items_counted
#			take = [stock-items_counted, moves[movement_counter]["quantity"].to_i].min
#			l=Line.find(moves[movement_counter]["line_id"].to_i)
#			logger.debug "take" + take.to_s
#			logger.debug "couldnt find line#" +  moves[movement_counter]["line_id"].to_i.to_s if !l
#			logger.debug "take=#{take.to_s}"
#			logger.debug "m.value=#{m.value.to_s}"
#			totalcost += (l.price||0)*(take||0)
#			logger.debug items_counted.inspect
#			items_counted = items_counted + take
#			end
#			movement_counter = movement_counter + 1
#		end
		if stock > 0
			logger.debug "totalcost=#{totalcost.to_s}"
			logger.debug "stock=#{stock.to_s}"
			return totalcost/stock
		else
			return 0
		end
	end
	def producttype
 		product_type.name if product_type
	end
	def min(location_id = User.current_user.location_id)
		i=inventories.find_by_entity_id(location_id)
		return i.min if i
	end
	def min=(value, location_id = User.current_user.location_id)
		i=inventories.find_by_entity_id(location_id)
		if i
			i.min=value 
			return i.save
		end
	end
	def max(location_id = User.current_user.location_id)
		i=inventories.find_by_entity_id(location_id)
		return i.max if i
	end
	def max=(value, location_id = User.current_user.location_id)
		i=inventories.find_by_entity_id(location_id)
		if i
			i.max = value
			return i.save
		end
	end
	def quantity(location_id = User.current_user.location_id)
		if self.product_type_id!=4
			i=inventories.find_by_entity_id(location_id)
			return i.quantity if i
		else
			return nil
		end
	end
	def quantity=(location_id = User.current_user.location_id)
		i=inventories.find_by_entity_id(location_id)
		if i
			i.quantity = value
			return i.save
		end
	end
	def on_order(location_id = User.current_user.location_id)
		list=self.lines.find(:all, :conditions => 'orders.order_type_id=2 AND lines.received is null AND orders.client_id=' + location_id.to_s, :joins => 'left join orders on orders.id=lines.order_id')
		return list.sum(&:quantity)
	end
	def sales_waiting(location_id = User.current_user.location_id)
		list=self.lines.find(:all, :conditions => 'orders.order_type_id=1 AND lines.received is null AND orders.vendor_id=' + location_id.to_s, :joins => 'left join orders on orders.id=lines.order_id')
		return list.sum(&:quantity)
	end
	def to_order(location_id = User.current_user.location_id)
		i=inventories.find_by_entity_id(location_id)
		return i.to_order || 0 if i
	end
	def to_order=(value, location_id = User.current_user.location_id)
		i=inventories.find_by_entity_id(location_id)
		if i
			i.to_order = value
			return i.save
		end
	end
	def producttype=(name)
		self.product_type = ProductType.find_by_name(name) unless name.blank?
	end
	def unit_name
 	 unit.name if unit
	end
	def unit_name=(name)
		self.unit = Unit.find_or_create_by_name(name) unless name.blank?
	end
	def available(price_group = User.current_user.current_price_group)
		priceobj = price_group.prices.find_by_product_id(self.id)
		if priceobj
			return priceobj.available
		end
	end
	def price(price_group = User.current_user.current_price_group, final=true)
		# final is a flag for returning prices for combos
		# it should only be set for combos
		# when it is true this function will return the total value of all of the components
		if self.product_type_id == 2 or (self.product_type_id == 3 and final) # For calculating price of a discount or combo
			logger.debug "Getting price from requirements"
			priceobj = price_group.prices.find_by_product_id(self.id)
			if priceobj
				logger.debug "found priceobj"
				relative_price = (priceobj.relative||0)
				static_price = (priceobj.fixed||0)
			else
				logger.debug "unable to find priceobj"
				relative_price =0
				static_price =0
			end
			sum = 0
			for req in self.requirements
				logger.debug "checking a req"
				sum += req.price(price_group)
			end
			logger.debug "sum=#{sum.to_s}"
			if self.product_type_id == 2
				price = (sum * relative_price) - static_price
			else
				price = (sum * relative_price) + static_price
			end
			logger.debug "price1=#{price.to_s}"
		elsif (self.product_type_id == 3 and !final)
			return (static_price||0)
		else
			priceobj = price_group.prices.find_by_product_id(self.id)
			relative_price = priceobj.relative
			static_price = priceobj.fixed
			price = (cost(price_group.entity)||0) * (relative_price||0) + (static_price||0)
		end
		logger.debug "price2=#{price.to_s}"
		return price
	end
	def relative_price(price_group = User.current_user.current_price_group)
		priceobj = price_group.prices.find_by_product_id(self.id)
		if priceobj
			return priceobj.relative
		end
	end
	def relative_price=(new_price, price_group = User.current_user.current_price_group)
		priceobj = price_group.prices.find_by_product_id(self.id)
		if priceobj
			priceobj.relative=new_price
			priceobj.save
		end
	end
	def static_price(price_group = User.current_user.current_price_group)
		priceobj = price_group.prices.find_by_product_id(self.id)
		if priceobj
			return priceobj.fixed
		end
	end
	def static_price=(new_price, price_group = User.current_user.current_price_group)
		priceobj = price_group.prices.find_by_product_id(self.id)
		if priceobj
			priceobj.fixed=new_price
			priceobj.save
		end
	end
	def cost(site = User.current_user.location)
		i = self.inventories.find_by_entity_id(site.id)
		if i
			if i.cost
			    return i.cost
			end
		end
		return 0
	end
	def cost=(new_cost, site = User.current_user.location)
		i = self.inventories.find_by_entity_id(site.id)
		if i
			i.cost=new_cost
			i.save
		end
	end
	def default_cost(site = User.current_user.location)
		i = self.inventories.find_by_entity_id(site.id)
		if i
			if i.default_cost
			    return i.default_cost
			end
		end
		return 0
	end
	def default_cost=(new_cost, site = User.current_user.location)
		i = self.inventories.find_by_entity_id(site.id)
		if i
			i.default_cost=new_cost
			i.save
		end
	end
	def show_upc
		if upc.to_s.length>12
			return upc.to_s[0..9]+'...'
		else
			return upc.to_s
		end
	end
	def get_serials
    return self.serialized_products.find(:all, :order => "serial_number")
  end
  def get_serials_here(site_id = current_user.location.id)
    @allserials = self.serialized_products.find(:all, :order => "serial_number")
    @serials=[]
    for s in @allserials
    	loc = s.location
    	if loc
	    	@serials << s if loc.id == site_id
    	end
    end
    return @serials
  end
	def create_requirements
		requirements.each do |requirement|
			requirement.product_id = self.id
			requirement.save(true)
		end		
	end
	def save_requirements
		requirements.each do |requirement|
			requirement.save(false)
		end
	end
   def self.search_all(search, page)
  	find 		 :all,
  					 :conditions => ['(products.name like :search OR products.model like :search OR description like :search OR vendors.name like :search OR product_categories.name like :search)', {:search => "%#{search}%"}],
		         :order => 'name',
		         :joins => 'inner join entities as vendors on vendors.id = products.vendor_id left join product_categories on product_categories.id=products.product_category_id',
		         :group => 'products.id'
	end
	def self.search_all_with_pages(search, page)
  	paginate :per_page => 20, :page => page,
		         :conditions => ['(products.name like :search OR products.model like :search OR products.upc like :search OR description like :search OR vendors.name like :search OR product_categories.name like :search)', {:search => "%#{search}%"}],
		         :order => 'name',
		         :joins => 'inner join entities as vendors on vendors.id = products.vendor_id left join product_categories on product_categories.id=products.product_category_id',
		         :group => 'products.id'
	end
	def self.search_name(search, page)
  	find 		 :all,
  					 :conditions => ['(products.name like :search)', {:search => "%#{search}%"}],
		         :order => 'name',
		         :limit => 10
	end
  def self.search(search, page)
  	paginate :per_page => 20, :page => page,
		         :conditions => ['(products.name like :search 
		         										OR products.model like :search 
		         										OR products.upc like :search 
		         										OR description like :search 
		         										OR vendors.name like :search 
		         										OR product_categories.name like :search)
		         							AND (prices.price_group_id = :price_group_id)
		         							AND (prices.available = True)',
		         							{:search => "%#{search}%", :price_group_id => User.current_user.current_price_group.id}],
		         :order => 'name',
		         :joins => 'inner join entities as vendors on vendors.id = products.vendor_id 
		         						inner join prices on prices.product_id=products.id
		         						left join product_categories on product_categories.id=products.product_category_id',
		         :group => 'products.id'
	end
	def self.search_for_services(search, page)
  	paginate :per_page => 20, :page => page,
		         :conditions => ['(products.name like :search 
		         								OR products.upc like :search 
		         								OR description like :search 
		         								OR product_categories.name like :search) 
		         								AND (prices.price_group_id = :price_group_id)
		         								AND (prices.available = True)
		         								AND (products.product_type_id=4)', {:search => "%#{search}%", :price_group_id => User.current_user.current_price_group.id}],
		         :order => 'name',
		         :joins => 'inner join prices on prices.product_id=products.id
		         						left join product_categories on product_categories.id=products.product_category_id',
		         :group => 'products.id'
	end
	def self.search_for_discounts(search, page)
  	paginate :per_page => 20, :page => page,
		         :conditions => ['(products.name like :search OR description like :search OR product_categories.name like :search) AND (products.product_type_id=2)', {:search => "%#{search}%", :current_location => "#{User.current_user.location_id}"}],
		         :order => 'name',
		         :joins => 'left join product_categories on product_categories.id=products.product_category_id',
		         :group => 'products.id'
	end
	def self.search_for_combos(search, page)
  	paginate :per_page => 20, :page => page,
		         :conditions => ['(products.name like :search OR description like :search OR product_categories.name like :search) AND (products.product_type_id=3)', {:search => "%#{search}%", :current_location => "#{User.current_user.location_id}"}],
		         :order => 'name',
		         :joins => 'left join product_categories on product_categories.id=products.product_category_id',
		         :group => 'products.id'
	end
	def self.search_all_wo_pagination(search, page)
  	find 		 :all,
		         :conditions => ['(products.name like :search OR products.model like :search OR products.upc like :search OR description like :search OR vendors.name like :search OR product_categories.name like :search)', {:search => "%#{search}%"}],
		         :order => 'name',
		         :joins => 'inner join entities as vendors on vendors.id = products.vendor_id left join product_categories on product_categories.id=products.product_category_id',
		         :group => 'products.id'
	end
end
