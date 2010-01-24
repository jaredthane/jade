class Employee < Entity
	belongs_to :price_group
	belongs_to :user
	belongs_to :site
end
