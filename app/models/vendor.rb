class Vendor < Entity
	belongs_to :user
	belongs_to :site
	belongs_to :tax_group
end
