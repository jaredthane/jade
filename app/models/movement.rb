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
	def post_create
		logger.debug "woking here"
		if e=product.inventory(entity)
			e.quantity+=quantity
			e.save
		end
	end
	def product_name
 	    product.name if product
 	    puts "++"+product.name
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
    def self.for_product_in_site(product_id, page, site_id = User.current_user.location_id)
        puts "product_id"+product_id.to_s
        puts "site_id"+site_id.to_s
        paginate :per_page => 20, :page => page,
		           :conditions => ['(products.id = :search) AND (entities.id=:current_location)', {:search => "#{product_id}", :current_location => "#{site_id}"}],
		           :order => 'movements.created_at DESC',
		           :joins => 'inner join products on products.id = movements.product_id inner join users on users.id = movements.user_id inner join entities on entities.id = movements.entity_id'
    end
#    def self.search(search, page)
#	    paginate :per_page => 20, :page => page,
#		           :conditions => ['(products.name like :search OR users.login like :search OR products.upc like :search) AND (entities.id=:current_location)', {:search => "%#{search}%", :current_location => "#{User.current_user.location_id}"}],
#		           :order => 'movements.created_at DESC',
#		           :joins => 'inner join products on products.id = movements.product_id inner join users on users.id = movements.user_id inner join entities on entities.id = movements.entity_id'
#    end
    def self.search(from, till, sites, search=nil, page=nil)
			till = till.to_date + 1
			sites_string="(" + (sites |[User.current_user.location_id]).collect{|a| a.to_s + ", "}.to_s.chop.chop + ")"
    	c="movements.created_at >= '#{from.to_s(:db)}' and movements.created_at < '#{till.to_s(:db)}' AND movements.entity_id in #{sites_string}"
    	c += " AND (products.name like '%#{search}%' OR products.upc like '%#{search}%')" if search
    	j="inner join products on products.id = movements.product_id" if search
	    o = "movements.created_at DESC"
		  if page
				paginate :per_page => 20, :page => page, :conditions => c, :order => o, :joins=>j
			else
				find :all, :conditions => c, :order => o, :joins=>j
			end
    end

end
