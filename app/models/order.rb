class Order < ActiveRecord::Base
	has_many :lines, :dependent => :destroy
	has_many :products, :through => :lines
	has_many :payments
	has_many :movements
	HUMANIZED_ATTRIBUTES = {
    :user => "Usuario",
    :ordered => "Fecha de Solicitud",
    :vendor => "Proveedor",
    :client => "Cliente"
  }
	attr_accessor :comments
  def self.human_attribute_name(attr)
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
  def validate
  	#puts "validating order"
  end
	after_update :save_lines
	after_create :create_lines
	belongs_to :vendor, :class_name => "Entity", :foreign_key => 'vendor_id'
	belongs_to :client, :class_name => "Entity", :foreign_key => 'client_id'
	validates_presence_of(:vendor, :message => "debe ser valido")
	validates_presence_of(:client, :message => "debe ser valido")
	validates_associated :lines
	belongs_to :user
	validates_presence_of(:user, :message => "debe ser valido")
	
	def get_discounts
  	product_type=ProductType.find(2)
    @discounts = product_type.products.find(:all, :order => "name")
  end
  def get_sum(product)
  	sum=0
  	o=Order.find(self.id)
  	#puts "num lines: " + o.lines.count.to_s
  	for line in o.lines
  		#puts "checking line#" + line.id.to_s
  		if line.product.id==product.id
  			#puts "found some"
  			sum+=line.quantity
  		end
  	end
  	return sum
  end
  def check_for_discounts
		for discount in get_discounts do #Go through each discount
			@qualify=100
			for req in discount.requirements do        #Check if the order has enough of each product
				@wehave = get_sum(req.required)
				@weneed = req.quantity
				#puts "@wehave ->" + @wehave.to_s + "<-"
				if @wehave == nil
					#puts "@wehave is null again"
				end
				#puts "@weneed ->" + @weneed.to_s + "<-"
				@temp = @wehave / @weneed
				@qualify= [@qualify, @temp].min
			end #req in discount.requirements
			if @qualify >= 1			                     		#If the order qualifies,
				##puts "It Qualifies!!!!!!!!!!!!!!!!!!!"
				l=Line.new(:order_id => self.id, :product_id => discount.id, :quantity => @qualify, :price => discount.price, :received => 1)
				l.save
			end #if qualify==1
		end #discount in get_discounts
	end #check_for_discounts
	
	def new_line_attributes=(line_attributes)
		#puts "trying to save lines"
		if !self.new_record?
			line_attributes.each do |attributes|
				line=lines.new(attributes)
				line.order_id = self.id
				line.save()
				##puts "line order_id set to " + line.order_id.to_s
				##puts "line product name is " + line.product.name
			end
		end
	end
	
	def existing_line_attributes=(line_attributes)
		#puts "line attributes=" + line_attributes.to_s
		lines.reject(&:new_record?).each do |line|
			attributes = line_attributes[line.id.to_s]
			if attributes
				line.attributes = attributes
				line.save
			else
				lines.delete(line)
			end
		end
	end
	
	def total_price
		total=0
		for l in self.lines
			total = total + (l.total_price)
		end
		return total
	end
	def total_tax
		total=0
		for l in self.lines
			total = total + (l.tax)
		end
		return total
	end
	def total_price_with_tax
		total=0
		for l in self.lines
			total = total + (l.total_price_with_tax)
		end
		return total
	end
	def amount_paid
		return self.payments.sum(:amount, :conditions => ['order_id = :order_id', {:order_id => self.id}])
	end
	def vendor_name
		vendor.name if vendor
	end
	def vendor_name=(name)
		self.vendor = Entity.find_by_name(name) unless name.blank?
	end
	def client_name
		client.name if client
	end
	def client_name=(name)
		self.client = Entity.find_by_name(name) unless name.blank?
	end
	def user_name
		user.login if user
	end
	def user_name=(name)
		self.user = User.find_by_login(name) unless name.blank?
	end
	
	def order_type
		if self.vendor.entity_type.id == 3 
			 if self.client.entity_type.id == 3 
				 'transfers' 
			 else 
				 'sales' 
			 end 
		else 
			 if self.client.entity_type.id == 3 
				 'purchases' 
			 else 
				 'other' 
			 end 
		 end
	end
	def save_lines
		lines.each do |line|
			line.save(false)
		end
	end
	def create_lines
		#puts "creating lines"
		lines.each do |line|
			#puts "setting order_id to " + self.id.to_s
			line.order_id = self.id 
			line.save(true)
		end		
	end
	def last_received
		##puts "Checking for order number "+self.id.to_s
		@received=nil
		for line in self.lines do
			return nil if line.received == nil
			if @received == nil
				@received=line.received
				##puts line.product.name + " was received " + line.received.to_s + " 2received set to "+@received.to_s
			else 
				if line.received > @received
					##puts line.product.name + " was received " + line.received.to_s + " received is already "+@received.to_s
					@received=line.received
					##puts line.product.name + " was received " + line.received.to_s + " 1received set to "+@received.to_s
				end
			end
		end
		return @received
	end
	def self.search(search, page)
		paginate :per_page => 20, :page => page,
						 :conditions => ['(vendors.name like :search OR clients.name like :search OR orders.id like :search) AND (vendors.id=:current_location OR clients.id=:current_location)', {:search => "%#{search}%", :current_location => "#{User.current_user.location_id}"}],
						 :order => 'created_at desc',
						 :joins => "inner join entities as vendors on vendors.id = orders.vendor_id inner join entities as clients on clients.id = orders.client_id"
	end
	def self.search_sales(search, page)
		paginate :per_page => 20, :page => page,
						 :conditions => ['(vendors.entity_type_id = 3 and clients.name like :search) AND (vendors.id=:current_location OR clients.id=:current_location)', {:search => "%#{search}%", :current_location => "#{User.current_user.location_id}"}],
						 :order => 'created_at desc',
						 :joins => "inner join entities as vendors on vendors.id = orders.vendor_id inner join entities as clients on clients.id = orders.client_id"
	end
	def self.search_purchases(search, page)
		paginate :per_page => 20, :page => page,
						 :conditions => ['(vendors.name like :search and clients.entity_type_id = 3) AND (vendors.id=:current_location OR clients.id=:current_location)', {:search => "%#{search}%", :current_location => "#{User.current_user.location_id}"}],
						 :order => 'created_at desc',
						 :joins => "inner join entities as vendors on vendors.id = orders.vendor_id inner join entities as clients on clients.id = orders.client_id"
	end
	def self.search_batch(search, page)
		paginate :per_page => 20, :page => page,
						 :conditions => ['(last_batch=True) AND (vendors.name like :search OR clients.name like :search OR orders.id like :search) AND (vendors.id=:current_location OR clients.id=:current_location)', {:search => "%#{search}%", :current_location => "#{User.current_user.location_id}"}],
						 :order => 'created_at desc',
						 :joins => "inner join entities as vendors on vendors.id = orders.vendor_id inner join entities as clients on clients.id = orders.client_id"
	end
end
