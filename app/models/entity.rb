class Entity < ActiveRecord::Base
	validates_presence_of(:name, :message => "Debe introducir el nombre de la entidad.")
  validates_uniqueness_of(:name, :message => "El nombre de entidad ya existe.") 
  
  belongs_to :state
  
  # These are all of the price groups that are available at this site.
  # For use with Sites
  has_many :price_groups
  
  # This is the default price Group Name to use for this client
  # For use with Clients
  belongs_to :price_group_name
  
  # This is the default price group to be used if a clients normal price group isn't available here
  # to be used with Sites
  belongs_to :price_group
  
	has_many :orders, :order => 'created_at'
	has_many :products, :through => :inventories
	has_many :products, :through => :movements
	has_many :movements, :dependent => :destroy, :order => 'created_at'
	validates_associated :movements
	after_update :save_movements
  after_create :save_movements
	
	belongs_to :entity_type
	validates_presence_of(:entity_type, :message => "Debe seleccionar el tipo de entidad.")
	
  def new_movement_attributes=(movement_attributes)
    movement_attributes.each do |attributes|
      movements.build(attributes)
    end
  end
#  def price_group(location_id = User.current_user.location_id)
#  	location = Entity.find(location_id)
#  	pg = location.price_groups.find_by_name_id(self.default_price_group_id)
#  	if !pg
#  		pg = location.price_groups.find_by_name_id(self.price_group_name_id)
#  	end
#  	return pg
#  end
  def strip(s, c)
   clean=''
   s.each_char do |l|
		 if !c.include?(l)
		 	clean << l
		 end
   end
   return clean; 
  end
  def existing_movement_attributes=(movement_attributes)
    movements.reject(&:new_record?).each do |movement|
      attributes = movement_attributes[movement.id.to_s]
      if attributes
        movement.attributes = attributes
      else
        movements.delete(movement)
      end
    end
  end
  def products_to_order
  	products_to_order = 0
  	condition='vendor_id=' + id.to_s
  	for p in Product.find(:all, :conditions => condition)
  		if p.to_order(4) > 0
  			products_to_order += 1
  		end
  	end
  	return products_to_order
  end
  def save_movements
    movements.each do |movement|
      movement.save(false)
    end
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
  def self.search(search, page, entity_type='all')
  	#puts "search=" + search
  	search = search || ""
  	#puts "search=" + search
  	case entity_type
			when 'clients'
				condition = "entities.name like '%" + search +"%' AND (entity_type_id = 2 OR entity_type_id = 5)"
			when 'end_users'
				condition = "entities.name like '%" + search +"%' AND entity_type_id = 2"
			when 'wholesale_clients'
				condition = "entities.name like '%" + search +"%' AND entity_type_id = 5"
			when 'vendors'
				condition = "entities.name like '%" + search +"%' AND entity_type_id = 1"
			when 'sites'
				condition = "entities.name like '%" + search +"%' AND entity_type_id = 3"
			else
				condition = "entities.name like '%" + search +"%'"
  	end
  	#puts "condition=" + condition
		paginate :per_page => 20, :page => page,
		       :conditions => condition,
		       :order => 'name'
	end
	def self.search_birthdays(search)
		search = search || ""
  	list = find :all,
		         		:conditions => "entities.name like '%" + search + "%' AND (entity_type_id = 2 OR entity_type_id = 5)",
		        		:order => 'name'
		list.delete_if {|x| !x.birthday? }
		return list
	end
	def birthday?
		logger.debug "self.birth=#{self.birth.inspect}"
		if self.birth.strftime("%j") == Time.now.strftime("%j")
			return true
		else
			return false
		end
	end
	def inventory(product)
		puts "product.id=" + product.id.to_s
		puts "self.id=" + self.id.to_s
		if product.inventories.find_by_entity_id(self.id)
			return product.inventories.find_by_entity_id(self.id).quantity
		else
			return 0
		end
	end
end
