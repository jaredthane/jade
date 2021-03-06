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
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	def get_sites
    @clients = Entity.find(:all, :order => "name", :conditions =>"entity_type_id=3")
  end
  def get_entity_types
    @entity_types = EntityType.find(:all, :order => "name")
  end
  def get_client_types
    @client_types = EntityType.find(:all, :conditions => 'id=2 or id=5', :order => "name")
  end
  def get_privileges
    @privileges = Privilege.find(:all, :order => "name")
  end
  def get_price_group_names
    @price_group_names = PriceGroupName.find(:all, :conditions => ['price_groups.entity_id=:site_id', {:site_id => "#{current_user.location_id}"}], :order => "name", :joins => 'inner join price_groups on price_groups.price_group_name_id=price_group_names.id')
  end
  def get_price_groups
#    @price_groups = PriceGroup.connection.execute(['SELECT price_groups.id, price_group_names.name FROM price_groups
#    					inner join price_group_names on price_groups.price_group_name_id=price_group_names.id
#    					where price_groups.entity_id=:site_id
#    					order_by name
#    					', {:site_id => "#{current_user.location.id}"}])
#@price_groups = PriceGroup.connection.select_all('select * from price_groups inner join price_group_names on price_groups.price_group_name_id=price_group_names.id where price_groups.entity_id=49')
    list = PriceGroup.find(:all, :conditions => ['price_groups.entity_id=:site_id', {:site_id => "#{current_user.location.id}"}])
#    @price_groups=[]
#    for pg in list
#    	new=PriceGroupWithNames.new()
#    	new.attributes=
#    end
  end
  def get_states
    @states = State.find(:all, :order => "name")
  end
  def get_accounts
    @accounts = Account.find(:all, :order => "number")
  end
  def get_parent_accounts
    @accounts = Account.find(:all, :conditions=>'is_parent=1', :order => "number")
  end
  def get_child_accounts
    @accounts = Account.find(:all, :conditions=>'is_parent=0', :order => "number")
  end
  def get_users
    @users = User.find(:all, :order => "login")
  end
  def get_products
    @products = Product.find(:all, :order => "name")
  end
  def get_product_categories
    @product_categories = ProductCategory.find(:all, :order => "name")
  end
  def get_units
    @units = Unit.find(:all, :order => "name")
  end
  def get_warranties(product)
    @warranties = product.warranties
  end
  def get_orders
    @orders = Order.find(:all, :order => "id")
  end
  def get_payment_methods
    @payment_methods = PaymentMethod.find(:all, :order => "name")
  end
  def get_movement_types
    @movement_types = MovementType.find(:all, :order => "name")
  end
  def get_vendors
    @vendors = Entity.find(:all, :order => "name", :conditions =>"entity_type_id=1")
  end
  def get_roles
    @roles = Role.find(:all, :order => "title")
  end
  def get_locations
  	entity_type=EntityType.find(3)
    @locations = entity_type.entities.find(:all, :order => "name")
  end
  def get_discounts
  	product_type=ProductType.find(2)
    @discounts = product_type.products.find(:all, :order => "name")
  end
  def get_entities
	  @entity = Entity.find(:all, :order => "name")
  end
  def get_clients
    @clients = entity_type.entities.find(:all, :order => "name", :conditions =>"entity_type_id=2 OR entity_type_id=5")
  end
  def get_serials(product_id)
    return Product.find(product_id).get_serials
  end
  def get_serials_here(product_id, site_id = current_user.location.id)
    return Product.find(product_id).get_serials_here(site_id)
  end
  def printline(text, value, x, y, height, pdf)
		pdf.bounding_box [x,y], :width => 250 do
			pdf.stroke_line([pdf.bounds.left,pdf.bounds.top-10,pdf.bounds.right,pdf.bounds.top-10])
			pdf.text text, :style => :bold
			pdf.text(value||'')
		end
		return y-height
	end
	def js_list(entries, field, phrase = nil)
    return unless entries
    items = entries.map { |entry| phrase ? highlight(entry[field], phrase) : h(entry[field])+"|" }
    return items.to_s.chop
  end
  def date_selection
    selection=[]
    for i in (0..3)
      selection << [("Hace " + (5-i).to_s + " años"), (Date.today << (12*(5-i))).to_s]
    end
    selection << ["Hace 18 meses",(Date.today << 18).to_s]
    selection << ["Hace un año",(Date.today << 12).to_s]
    for i in (0..9)
      selection << ["Hace " + (11-i).to_s + " meses",(Date.today << (11-i)).to_s]
    end
    selection << ["Hace un mes",(Date.today << 1).to_s] 
    selection << ["Hace tres semanas",(Date.today - 21).to_s]
    selection << ["Hace dos semanas",(Date.today - 14).to_s]
    selection << ["Hace una semana",(Date.today - 7).to_s]
    
    for i in (0..4)
      selection << ["Hace " + (6 - i).to_s + " días",(Date.today - (6 - i)).to_s]
    end
    selection << ["Ayer",(Date.today - 1).to_s] 
    selection << ["Hoy",(Date.today).to_s] 
    selection << ["Mañana",(Date.today + 1).to_s]
    for i in (2..6)
      selection << ["En " + i.to_s + " días",(Date.today + i).to_s]
    end
    selection << ["En una semana",(Date.today + 7).to_s]
    selection << ["En dos semanas",(Date.today + 14).to_s]
    selection << ["En tres semanas",(Date.today + 21).to_s]
    selection << ["En un mes",(Date.today >> 1).to_s]
    for i in (2..11)
      selection << ["En " + i.to_s + " meses",(Date.today >> i).to_s]
    end
    selection <<  ["En un año",(Date.today >> 12).to_s]
    for i in (2..5)
      selection << ["En " + i.to_s + " años",(Date.today >> i*12).to_s]
    end
    return selection
  end
  def remove_link_unless_new_record(fields)
    unless fields.object.new_record?
      out = ''
      out << fields.hidden_field(:_delete)
      out << link_to_function("remove", "$(this).up('.#{fields.object.class.name.underscore}').hide(); $(this).previous().value = '1'")
      out
    end
  end
  
  # These use the current date, but they could be lots easier.
  # Maybe just keep a global counter which starts at 10 or so.
  # That would be good enough if we only build 1 new record in the controller.
  #
  # And this of course is only needed because Ryan's example uses JS to add new
  # records. If you just build a new one in the controller this is all unnecessary.
  
  def add_task_link(name, form)
    link_to_function name do |page|
      page << %{
var new_prod_line_id = "new_" + new Date().getTime();
$("#prod_line_model").contents().clone().prependTo("#prod_lines");

}
    end
  end
  


  
end
