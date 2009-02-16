# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	def get_locations
    @locations = Location.find(:all, :order => "name")
  end
  def get_entity_types
    @entity_types = EntityType.find(:all, :order => "name")
  end
  def get_privileges
    @privileges = Privilege.find(:all, :order => "name")
  end
  def get_price_group_names
    @price_group_names = PriceGroupName.find(:all, 
    					:conditions => ['price_groups.entity_id=:site_id', {:site_id => "#{current_user.location.id}"}], 
    					:order => "name", 
    					:joins => 'inner join price_groups on price_groups.price_group_name_id=price_group_names.id')
  end
  def get_states
    @states = State.find(:all, :order => "name")
  end
  def get_users
    @users = User.find(:all, :order => "login")
  end
  def get_products
    @products = Product.find(:all, :order => "name")
  end
  def get_product_categories
    @product_categories = ProductCategory.find(:all, :order => "name")
  end
  def get_units
    @units = Unit.find(:all, :order => "name")
  end
  def get_warranties(product)
    @warranties = product.warranties
  end
  def get_orders
    @orders = Order.find(:all, :order => "id")
  end
  def get_payment_methods
    @payment_methods = PaymentMethod.find(:all, :order => "name")
  end
  def get_movement_types
    @movement_types = MovementType.find(:all, :order => "name")
  end
  def get_vendors
    @vendors = Entity.find(:all, :order => "name", :conditions =>"entity_type_id=1")
  end
  def get_locations
  	entity_type=EntityType.find(3)
    @locations = entity_type.entities.find(:all, :order => "name")
  end
  def get_discounts
  	product_type=ProductType.find(2)
    @discounts = product_type.products.find(:all, :order => "name")
  end
  def get_entities
	  @entity_types = Entity.find(:all, :order => "name")
  end
  def get_clients
    @clients = entity_type.entities.find(:all, :order => "name", :conditions =>"entity_type_id=2 OR entity_type_id=5")
  end
  def get_serials(product_id, location_id)
    product = Product.find(product_id)
    @serials = product.serialized_products.find(:all, :conditions =>"location_id == #{location_id}", :order => "name")
  end
end
