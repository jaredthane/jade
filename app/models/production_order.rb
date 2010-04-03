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

class ProductionOrder < ActiveRecord::Base
  has_many :production_lines
  has_many :consumption_lines
  belongs_to :site, :class_name => "Entity", :foreign_key => 'site_id'
  belongs_to :created_by, :class_name => "User", :foreign_key => "created_by_id"
  belongs_to :started_by, :class_name => "User", :foreign_key => "started_by_id"
  belongs_to :finished_by, :class_name => "User", :foreign_key => "finished_by_id"

  accepts_nested_attributes_for :production_lines, :allow_destroy => true
  accepts_nested_attributes_for :consumption_lines, :allow_destroy => true
  validates_associated :production_lines, :consumption_lines
	##################################################################################################
	# Validates Production Order
	#################################################################################################
  def validate
    errors.add "Nombre","no puede dejarse en blanco." if !name or name==''
    if self.new_record? and is_process==1
    	errors.add "Nombre","debe ser único" if ProductionOrder.find(:first,:conditions=> "name = '#{name} AND is_process=1'")
    end
  end
  def new_production_order(params={})
  	params={:name=>self.name, :site=>self.site, :quantity=>1, :is_process=>false, :created_at=>User.current_user.today, :created_by=>User.current_user}.merge!(params)
  	puts params.inspect
  	po=ProductionOrder.new(params)
  	for line in self.consumption_lines
  		po.consumption_lines << ConsumptionLine.new(line.attributes)
  	end
  	for line in self.production_lines
  		po.production_lines << ProductionLine.new(line.attributes)
  	end
  	return po
  end
  def title
  	if is_process
  		return 'Proceso de Produccion'
  	else
  		return 'Orden de Produccion'  		
  	end # if is_process
  end
  ##############################################################
  # Starts production
  # Creates movements to remove consumed items from stock
  ##############################################################
  def start(params={})
  	params={:started_at => User.current_user.today, :started_by => User.current_user}.merge!(params)
  	self.started_at=params.delete(:started_at)
		self.started_by=params.delete(:started_by)
		for l in self.production_lines
			l.quantity_planned = l.quantity_planned * self.quantity
			l.quantity = l.quantity_planned
		end
		for l in self.consumption_lines
			l.quantity = l.quantity * self.quantity
			l.start_movement(params)
		end
		self.quantity=1
  end # def start
  ##############################################################
  # Calculates and caches cost of production
  ##############################################################
  attr_accessor :local_cost
  def cost
  	if !local_cost
  		c=consumption_lines.inject(0) { |result, element| result + element.cost }
  		local_cost = (quantity||1) * (c||0)
  	end
  	return local_cost
  end # def cost
  ##############################################################
  # Finishes Production
  # Creates movements to bring produced products into stock
  ##############################################################
  def finish(params={})
  	params={:finished_at => User.current_user.today, :finished_by => User.current_user}.merge!(params)
  	self.finished_at=params.delete(:finished_at)
		self.finished_by=params.delete(:finished_by)
		for l in self.production_lines
          Cost.create(:product=>l.product, :quantity=>l.quantity, :value=>l.total_cost/l.quantity, :entity=>self.site)
#			
#			
#			
#			old_cost=l.product.cost
#			logger.debug "old_cost=#{old_cost.to_s}"
#			logger.debug "old_qty=#{old_qty.to_s}"
#			logger.debug "l.total_cost=#{l.total_cost.to_s}"
#			logger.debug "l.quantity=#{l.quantity.to_s}"
#			logger.debug "(old_cost*old_qty+l.total_cost)=#{(old_cost*old_qty+l.total_cost).to_s}"
#			logger.debug "(old_qty+l.quantity)=#{(old_qty+l.quantity).to_s}"
#			logger.debug "(old_cost*old_qty+l.total_cost)/(old_qty+l.quantity)=#{((old_cost*old_qty+l.total_cost)/(old_qty+l.quantity)).to_s}"
#			l.product.cost = (old_cost*old_qty+l.total_cost)/(old_qty+l.quantity)
		end # for l in self.production_lines
		for l in self.production_lines
			l.finish_movement(params)
		end

  end # def finish
  #################################################################################################
  # Searches for product orders and product processes based on name and filter
  # Paginates if page is specified
  #################################################################################################
  def self.search(search, filter = '', page=nil)
		c = "(name like '%#{search}%' or id=#{search.to_i})"
		o = 'production_orders.name'
		case filter
		when 'processes'
			c += ' AND is_process=1'
		when 'orders'
			c += ' AND is_process=0'
		end
		if page
  		paginate :per_page => 20, :page => page, :conditions => c, :order => o
  	else
  		find :all, :conditions => c, :order => o
  	end
	end
end
