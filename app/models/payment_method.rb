class PaymentMethod < ActiveRecord::Base
has_many :payments
end
