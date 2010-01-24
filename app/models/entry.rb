class Entry < ActiveRecord::Base
	belongs_to :movement
	belongs_to :account
	belongs_to :product
	belongs_to :serial
end
