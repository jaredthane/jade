class Payment < ActiveRecord::Base
	belongs_to :order
	belongs_to :payment_method
	belongs_to :user
	def self.search(search, page)
  	paginate :per_page => 20, :page => page,
		         :conditions => ['(payments.order_id like :search OR payment_methods.name like :search )', {:search => "%#{search}%"}],
		         :order => 'payments.created_at',
		         :joins => 'inner join orders on orders.id = payments.order_id inner join payment_methods on payment_methods.id = payments.payment_method_id'
	end
end
