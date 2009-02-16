class SerializedProduct < ActiveRecord::Base
	has_many :lines
	has_many :movements
	belongs_to :product
	def location
		if self.lines.find(:last, :order=> 'received')
			self.lines.find(:last, :order=> 'received').order.client
		else
			return nil
		end
	end
	def self.search(search, page)
  	paginate :per_page => 20, :page => page,
		         :conditions => ['(serial_number like :search OR upc like :search OR name like :search)', {:search => "%#{search}%"}],
		         :order => 'serial_number',
		         :joins => 'left join products on products.id = serialized_products.product_id'
	end
end
