class Product < ActiveRecord::Base

	HUMANIZED_ATTRIBUTES = {
    :unit => "Unidad",
    :upc => "UPC",
    :name => "Nombre"
  }

  def self.human_attribute_name(attr)
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
  has_many :warranties
  has_many :inventories
	has_many :lines
	belongs_to :product_category
	has_many :movements
	has_many :requirements, :dependent => :destroy
	after_update :save_requirements
	after_create :create_requirements
	belongs_to :product_type
	belongs_to :unit
	validates_presence_of(:unit, :message => "debe ser valido")
	validates_presence_of(:name, :message => "debe ser valido.")
	validates_uniqueness_of(:name, :message => "debe ser único.") 
	validates_uniqueness_of(:upc, :message => "debe ser único.") 

	belongs_to :vendor, :class_name => "Entity", :foreign_key => 'vendor_id'
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
	def calculate_cost(location_id = User.current_user.location_id)
		moves = movements.find_all_by_entity_id(location_id, :order => 'created_at desc')
		num_movements = movements.count
		stock = self.quantity
		items_counted = 0
		movement_counter = 0
		totalcost=0
		while	(items_counted < stock) and (movements[movement_counter]) do
			#puts "stock" + stock.inspect
			#puts "items_counted" + items_counted.inspect
			#puts "movements[movement_counter].quantity" + movements[movement_counter].quantity.inspect
			#puts "stock-items_counted" + (stock-items_counted).inspect
			#puts "[stock-items_counted, movements[movement_counter].quantity].min=" + [stock-items_counted, movements[movement_counter].quantity].min.inspect
			take = [stock-items_counted, movements[movement_counter].quantity].min
			totalcost += movements[movement_counter].line.price
			#puts items_counted.inspect
			items_counted = items_counted + take
			movement_counter = movement_counter + 1
		end
		if stock > 0
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
		i=inventories.find_by_entity_id(location_id)
		return i.quantity if i
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
	def price
		relative_price
		return (cost||0)*(relative_price||0)+(static_price||0)
	end
	def new_requirement_attributes=(requirement_attributes)
		#puts "saving new attributes"
		#puts "requirement_attributes we received has "+ requirement_attributes.to_s
		requirement_attributes.each do |attributes|
			#puts "ready to save attributes=" + attributes.to_s 
			requirement=requirements.new(attributes)
			requirement.product_id = self.id
			requirement.save()
		end
	end
	def requirement_attributes=(requirement_attributes)
		##puts "requirement_attributes we received has "+ requirement_attributes.to_s
		requirements.reject(&:new_record?).each do |requirement|													#Go through each existing attribute
			##puts "ready to save attributes requirement=" + requirement.to_s 
			##puts "requirement.id=" + requirement.id.to_s 
			attributes = requirement_attributes[requirement.id.to_s]												#Grab new values
			if attributes
				##puts "saving attributes" + attributes.to_s
				requirement.attributes = attributes																						#stick them in the requirement
				requirement_attributes.delete(requirement) 																		#remove requirement from the list
			else																																						#if its not in the list, delte it.
				##puts "deleting requirement " + requirement.required.name
				requirements.delete(requirement)
			end
		end
		#puts requirement_attributes.inspect
		requirement_attributes.each_value do |attributes|																				#Go through all the leftover ones
			#puts "ready to save attributes=" + attributes.to_s 
			requirement=requirements.new(attributes)																				# and create them
			requirement.product_id = self.id
			requirement.save()
		end
	end
	def existing_requirement_attributes=(requirement_attributes)
		#puts "requirement_attributes we received has "+ requirement_attributes.to_s
		requirements.reject(&:new_record?).each do |requirement|
			#puts "ready to save attributes requirement=" + requirement.to_s 
			#puts "requirement.id=" + requirement.id.to_s 
			attributes = requirement_attributes[requirement.id.to_s]
			if attributes
				#puts "saving attributes" + attributes.to_s
				requirement.attributes = attributes
			else
				#puts "deleting requirement " + requirement.required.name
				requirements.delete(requirement)
			end
		end
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
		         :conditions => ['(products.name like :search OR products.model like :search OR products.upc like :search OR description like :search OR vendors.name like :search OR product_categories.name like :search) AND (locations.id=:current_location)', {:search => "%#{search}%", :current_location => "#{User.current_user.location_id}"}],
		         :order => 'name',
		         :joins => 'inner join entities as vendors on vendors.id = products.vendor_id inner join movements on movements.product_id = products.id inner join entities as locations on locations.id= movements.entity_id left join product_categories on product_categories.id=products.product_category_id',
		         :group => 'products.id'
	end
	def self.search_for_services(search, page)
  	paginate :per_page => 20, :page => page,
		         :conditions => ['(products.name like :search OR products.upc like :search OR description like :search OR product_categories.name like :search) AND (products.product_type_id=4)', {:search => "%#{search}%"}],
		         :order => 'name',
		         :joins => 'left join product_categories on product_categories.id=products.product_category_id',
		         :group => 'products.id'
	end
	def self.search_for_discounts(search, page)
  	paginate :per_page => 20, :page => page,
		         :conditions => ['(products.name like :search OR description like :search OR product_categories.name like :search) AND (products.product_type_id=2)', {:search => "%#{search}%", :current_location => "#{User.current_user.location_id}"}],
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
