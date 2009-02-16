class Warranty < ActiveRecord::Base
	has_many :lines
	belongs_to :product
	
	def self.search(search, page)
  	paginate :per_page => 20, :page => page,
		         :conditions => ['(products.name like :search or products.upc like :search)', {:search => "%#{search}%"}],
		         :order => 'products.name',
		         :joins => 'inner join products on products.id = warranties.product_id'
	end
end
