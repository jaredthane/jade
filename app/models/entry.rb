class Entry < ActiveRecord::Base
	belongs_to :movement
	belongs_to :account
	belongs_to :product
	belongs_to :serial
	belongs_to :entity
	
	#################################################################################################
	# Prepares an Entry to be created
	# -Updates its created_at to match that of its parent movement
	# -Sets its balance to the current balance of the account
	#################################################################################################
	before_save :prepare_for_save
	def prepare_for_save
		#Set created_at to match the Trans
		self.created_at=movement.created_at if movement
		# Calculate balance
		calculate_balance
	end
	
	#################################################################################################
	# Calculates the current balance of this account up to the current date
	#################################################################################################
	def calculate_balance
		return 0 if !self.account
    mydate=(self.created_at||Time.now)
	  last_entry=Entry.last(:conditions=> ['date(created_at) < :mydate AND account_id=:account', {:mydate=>mydate.to_s(:db), :account=>self.account_id}])
	  last_balace = last_entry ? (last_entry.balance || 0 ) : 0
	  change = (self.value || 0) * (self.multiplier || 0) * (self.account.modifier || 0)
	  self.balance = last_balace + change
	end # def calculate_balance
end
