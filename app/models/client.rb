class Client < Entity
	belongs_to :price_group
	belongs_to :user
	belongs_to :site
	belongs_to :tax_group
end
