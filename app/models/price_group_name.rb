class PriceGroupName < ActiveRecord::Base
	has_many :price_groups
	has_many :users
	def price_group(location_id = User.current_user.location_id)
  	pg = price_groups.find_by_entity_id(location_id)
  	if !pg
  		pg = Entity.find(location_id).price_group(location_id)
  	end
  	return pg
  end
end
