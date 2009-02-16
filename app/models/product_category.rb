class ProductCategory < ActiveRecord::Base
	has_many :products
	def self.search(search, page)
		paginate :per_page => 20, :page => page,
	         :conditions => ['name like :search', {:search => "%#{search}%"}],
	         :order => 'name'
	end
end
