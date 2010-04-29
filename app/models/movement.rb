# Jade Inventory Control System
#Copyright (C) 2009  Jared T. Martin

#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.

#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.

#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class Movement < ActiveRecord::Base
	belongs_to :movement_type
	belongs_to :product
	belongs_to :entity
	belongs_to :order
	belongs_to :line
	belongs_to :user
	belongs_to :cost_ref
	belongs_to :serialized_product
#	belongs_to :line

    SALE=1                      
    PURCHASE=2                        
    TRANSFER=3
    COUNT=4
    SALE_RETURN=5
    PURCHASE_RETURN=6
    TRANSFER_RETURN=7
    INTERNAL_CONSUMPTION=8
    INTERNAL_CONSUMPTION_RETURN=9
    
	before_create :post_create
	def description
		return "Cuenta Fisica" if movement_type_id==4
		d=movement_type.name
		if [1,2,3,8].include?(movement_type_id)
			if quantity>=0
				d+=" entregado"
			else
				d+=" recibido"
			end
		elsif [5,6,7,9].include?(movement_type_id)
			if quantity>=0
				d+=" recibido"
			else
				d+=" entregado"
			end
		end
	end
	#################################################################################################
    # Removes costs that have been sold
    # And returns the total cost
    #################################################################################################
    def self.consume(product, quantity, site, get_first=true)
       #puts "product=#{product.inspect}"
       #puts "site=#{site.inspect}"
       #puts "quantity=#{quantity.to_s}"
        c="product_id=#{product.id} AND entity_id=#{site.id} AND cost_left > 0"
        if get_first
            cost = first(:conditions=>c)
        else
            cost=last(:conditions=>c)
        end
        total=0
       #puts "cost=#{cost.inspect}"
        while quantity > 0 and cost
           #puts "quantity=#{quantity.to_s}"
           #puts "cost.quantity=#{cost.quantity.to_s}"
            amt = [quantity, cost.quantity_left].min
           #puts "amt=#{amt.to_s}"
            quantity -= amt
           #puts "cost.value=#{cost.value.to_s}"
           #puts "total=#{total.to_s}"
            cost_taken=(cost.cost_left/cost.quantity_left*amt).round(2)
            total += cost_taken
           #puts "total=#{total.to_s}"
           #puts "cost.quantity == amt=#{(cost.quantity == amt).to_s}"
            cost.quantity_left -= amt
            cost.cost_left -= cost_taken
            cost.save
            cost = first(:conditions=>"product_id=#{product.id} AND entity_id=#{site.id} AND cost_left > 0") 
            if quantity > 0
                if get_first
                    cost = first(:conditions=>c)
                else
                    cost=last(:conditions=>c)
                end
            end
        end
       #puts "total=#{total.to_s}"
        return total
    end # def self.consume(product, quantity, site)
    #################################################################################################
    # 
    #################################################################################################
    def self.stock_value(product, site)
        return sum('value_left * quantity_left', :conditions=>"product_id=#{product.id} AND entity_id=#{site.id}")
    end # def stock_value()
	def post_create
#		logger.debug "woking here"
		if e=product.inventory(entity)
			e.quantity+=quantity
			e.save
		end
	end
	def product_name
 	    product.name if product
 	   #puts "++"+product.name
	end
	def product_name=(name)
		self.product = Product.find_by_name(name) unless name.blank?
	end
	def entity_name
 	    entity.name if entity
	end
	def entity_name=(name)
		self.entity = Entity.find_by_name(name) unless name.blank?
	end
    def user_name
        user.login if user
    end
    def user_name=(name)
	    self.user = User.find_by_login(name) unless name.blank?
    end
    def self.for_product_in_site(product_id, page=nil, site_id = User.current_user.location_id)
#       #puts "product_id"+product_id.to_s
#       #puts "site_id"+site_id.to_s
      c="(products.id = #{product_id}) AND (entities.id=#{site_id})"
      o='movements.created_at'
      j='inner join products on products.id = movements.product_id inner join users on users.id = movements.user_id inner join entities on entities.id = movements.entity_id'
      if page  
        paginate :per_page => 20, :page => page, :conditions => c, :order => o, :joins => j
      else
        find :all, :conditions => c, :order => o, :joins=>j
      end
    end
    def self.clean_search(condition)
       	condition =condition.gsub("( AND ", "(")
       	condition =condition.gsub("( OR ", "(")
       	condition =condition.gsub("()", "")
       	condition =condition.gsub("()", "")
       	condition =condition.gsub("()", "")
       	condition =condition.gsub("AND )", ")")
       	condition="" if condition == " AND "
      	return condition
    end
    
    def self.search(from, till, sites, search=nil, page=nil)
    	till = till.to_date + 1
		sites_string="(" + (sites ||[User.current_user.location_id]).collect{|a| a.to_s + ", "}.to_s.chop.chop + ")"
#    	c="movements.created_at >= '#{from.to_s(:db)}' and movements.created_at < '#{till.to_s(:db)}' AND movements.entity_id in #{sites_string}"
      	search = search || ""  	
      	c="(movements.created_at >= '#{from.to_s(:db)}' and movements.created_at < '#{till.to_s(:db)}' AND movements.entity_id in #{sites_string}"
      	fields_to_search=['products.name','products.upc','clients.name','vendors.name']
      	j="inner join products on products.id=product_id inner join entities on entity_id=entities.id inner join movement_types on movement_types.id=movement_type_id inner join orders on orders.id=order_id inner join entities as vendors on vendors.id=orders.vendor_id inner join entities as clients on clients.id=client_id"
      	search_words=[]
      	words = search.downcase.split( / *"(.*?)" *| / ) 
      	for word in words
      	## Can filter for certain types of Movements thus: "tipo:Compra" or "tipo:Venta,Devolucion_de_Venta"
      		if word[0..4]=='tipo:'
      		    s = word[5..word.length+1]
      		    s = "'" + s.gsub(",", "','") + "'"
      		    s = s.gsub("_", " ")
      		    c += " AND movement_types.name in (#{s})"	
      		else
      			search_words << word
      		end
        end
        
        #add in actual searching of fields
      	c += " AND ("
      	for word in search_words
      		c+= " AND ("
      		for field in fields_to_search
      			c+= " OR " + field + " like '%" + word + "%'"
      		end
      		c += ")"
      	end
      	c += "))"
      	c=clean_search(c)
        o = "movements.created_at DESC"
	    if page
			paginate :per_page => 20, :page => page, :conditions => c, :order => o, :joins=>j
		else
			find :all, :conditions => c, :order => o, :joins=>j
		end
    end      			
      				
#    def self.search(search, page)
#	    paginate :per_page => 20, :page => page,
#		           :conditions => ['(products.name like :search OR users.login like :search OR products.upc like :search) AND (entities.id=:current_location)', {:search => "%#{search}%", :current_location => "#{User.current_user.location_id}"}],
#		           :order => 'movements.created_at DESC',
#		           :joins => 'inner join products on products.id = movements.product_id inner join users on users.id = movements.user_id inner join entities on entities.id = movements.entity_id'
#    end

#    def self.search(from, till, sites, search=nil, page=nil)
#			till = till.to_date + 1
#			sites_string="(" + (sites ||[User.current_user.location_id]).collect{|a| a.to_s + ", "}.to_s.chop.chop + ")"
#    	c="movements.created_at >= '#{from.to_s(:db)}' and movements.created_at < '#{till.to_s(:db)}' AND movements.entity_id in #{sites_string}"
#    	c += " AND (products.name like '%#{search}%' OR products.upc like '%#{search}%')" if search
#    	j="inner join products on products.id = movements.product_id" if search
#	    o = "movements.created_at DESC"
#		  if page
#				paginate :per_page => 20, :page => page, :conditions => c, :order => o, :joins=>j
#			else
#				find :all, :conditions => c, :order => o, :joins=>j
#			end
#    end

end
