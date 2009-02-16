class Movement < ActiveRecord::Base
	belongs_to :movement_type
	belongs_to :product
	belongs_to :entity
	belongs_to :order
	belongs_to :user
	belongs_to :serialized_product
	belongs_to :line

	def product_name
 	 product.name if product
 	 puts "++"+product.name
	end
	def product_name=(name)
		self.product = Product.find_by_name(name) unless name.blank?
	end
	def entity_name
 	 entity.name if entity
	end
	def entity_name=(name)
		self.entity = Entity.find_by_name(name) unless name.blank?
	end
	
  def user_name
 	 user.login if user
	end
	def user_name=(name)
		self.user = User.find_by_login(name) unless name.blank?
	end
	def self.search(search, page)
		paginate :per_page => 20, :page => page,
			       :conditions => ['(products.name like :search OR users.login like :search OR products.upc like :search) AND (entities.id=:current_location)', {:search => "%#{search}%", :current_location => "#{User.current_user.location_id}"}],
			       :order => 'movements.created_at DESC',
			       :joins => 'inner join products on products.id = movements.product_id inner join users on users.id = movements.user_id inner join entities on entities.id = movements.entity_id'
	end

end
