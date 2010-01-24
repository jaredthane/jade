class Purchsae < Order
	belongs_to :vendor, :foreign_key => 'vendor_id'
	belongs_to :site, :foreign_key => 'client_id'
end
