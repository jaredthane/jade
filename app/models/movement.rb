class Movement < ActiveRecord::Base
	belongs_to :contract, :class_name => "BaseContract", :foreign_key => 'object_id'
	belongs_to :blocker, :class_name => "User", :foreign_key => 'blocked_by'
	belongs_to :creator, :class_name => "User", :foreign_key => 'created_by'
	
	has_many :entries, :dependent => :destroy
	accepts_nested_attributes_for :entries, :allow_destroy => true
  validates_associated :entries
  
  FORWARD=1
  REVERSE=-1

	##############################################################
	# Allows you to make a new simple accounting transfer with just a to, from and value
	##############################################################
	def self.new_simple_accounting_transaction(params={})
		raise "You must specify which account you wish to transfer the money to" if !params[:to]
		raise "You must specify which account you wish to transfer the money from" if !params[:from]
		value=params.delete(:value)
		to=params.delete(:to)
		from=params.delete(:from)
		movement = new(params)
		value > 0 ? movement.direction = 1 : movement.direction = -1
		movement.entries << Entry.new(:value=>value*movement.direction, :multiplier=>-movement.direction, :account=>from)
		movement.entries << Entry.new(:value=>value*movement.direction, :multiplier=>movement.direction, :account=>to)
		return movement
	end # def simple_value
	
	##############################################################
	# Allows you to create a simple accounting transfer with just a to, from and value
	##############################################################
	def self.create_simple_accounting_transaction(params={})
		m = new_simple_accounting_transaction(params)
		return m if m.save
	end # def self.create_simple_transaction(params={})
	
	##############################################################
	# Allows you to make a new inventory transfer with just a to, from, product and quantity
	##############################################################
	def self.new_simple_inventory_transaction(params={})
		raise "You must specify which entity you wish to transfer the inventory to" if !params[:to]
		raise "You must specify which entity you wish to transfer the inventory from" if !params[:from]
		raise "You must specify which product you wish to transfer" if !params[:product]
		quantity=params.delete(:quantity)
		to=params.delete(:to)
		from=params.delete(:from)
		product=params.delete(:product)
		movement = new(params)
		movement.entries << Entry.new(:product=>product, :quantity=>(-quantity||0), :entity=>from)
		movement.entries << Entry.new(:product=>product, :quantity=>(quantity||0), :entity=>to)
		return movement
	end # def simple_quantity
	
	##############################################################
	# Allows you to create an inventory transfer with just a to, from, product and quantity
	##############################################################
	def self.create_simple_inventory_transaction(params={})
		m = new_simple_inventory_transaction(params)
		return m if m.save
	end # def self.create_simple_transaction(params={})
end
