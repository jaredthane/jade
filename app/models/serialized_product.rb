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
end
