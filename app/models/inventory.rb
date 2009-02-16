class Inventory < ActiveRecord::Base
	belongs_to :entity
	belongs_to :product
end
