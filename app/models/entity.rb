class Entity < ActiveRecord::Base
	validates_presence_of(:name, :message => "Debe introducir el nombre de la entidad.")
  validates_uniqueness_of(:name, :message => "El nombre de entidad ya existe.") 
  
  belongs_to :state
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
