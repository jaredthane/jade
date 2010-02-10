class User < ActiveRecord::Base
	def today
		self.date=Date.today if !self.date
		return Time.now.change(:year=>self.date.year, :month=>self.date.month, :day=>self.date.day)
	end
	def today=(value)
		self.date=value.to_date
	end
end

