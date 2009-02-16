class PriceGroup < ActiveRecord::Base
	has_many :prices
	belongs_to :entity
	belongs_to :price_group_name
	
	def self.search(search, page)
  	paginate :per_page => 20, :page => page,
		         :conditions => ['(payments.order_id like :search OR payment_methods.name like :search )', {:search => "%#{search}%"}],
		         :order => 'payments.created_at',
		         :joins => 'inner join orders on orders.id = payments.order_id inner join payment_methods on payment_methods.id = payments.payment_method_id'
	end
end
