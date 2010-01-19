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
    if self.new_record? and is_model==1
    	errors.add "Nombre","debe ser único" if ProductionOrder.find(:first,:conditions=> "name = '#{name} AND is_model=1'")
    end
  end
  def new_production_order
  	po=ProductionOrder.new(:name=>self.name, :is_model=>false, :created_at=>User.current_user.today, :created_by=>User.current_user)
  	for line in self.consumption_lines
  		po.consumption_lines << ConsumptionLine.new(line.attributes)
  	end
  	for line in self.production_lines
  		po.production_lines << ProductionLine.new(line.attributes)
  	end
  	return po
  end
  def title
  	if is_model
  		return 'Proceso de Produccion'
  	else
  		return 'Orden de Produccion'  		
  	end # if is_model
  end
  #################################################################################################
  # Searches for product orders and product processes based on name and filter
  # Paginates if page is specified
  #################################################################################################
  def self.search(search, filter = '', page=nil)
		c = "(name like '%#{search}%' or id=#{search.to_i})"
		o = 'production_orders.name'
		case filter
		when 'processes'
			c += ' AND is_model=1'
		when 'orders'
			c += ' AND is_model=0'
		end
		if page
  		paginate :per_page => 20, :page => page, :conditions => c, :order => o
  	else
  		find :all, :conditions => c, :order => o
  	end
	end
end