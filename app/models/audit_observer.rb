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

class AuditObserver < ActiveRecord::Observer
  observe :product, :order, :line, :entity, :inventory, :payment, :price, :price_group, :price_group_name, :product_category, :product_type, :requirement, :role, :serialized_product, :unit, :user, :warranty, :entity_type, :movement, :movement_type, :payment_method
  def write_to_log(msg, record)
  	Audit.info(msg)
  	#Log.create(:severity=>'info', :msg=>msg, :object_class=>record.class.to_s, :object_id=>record.id)
  end
  def after_update(record)
  	if User.current_user
  	  msg=User.current_user.login + " modifico: " + record.inspect
    else
      msg="Usuario desconocido modifico: " + record.inspect
    end
  	write_to_log(msg, record)
  end
  def after_create(record)
  	if User.current_user
    	msg=User.current_user.login + " creo: " + record.inspect
    else
    	msg="Usuario desconocido creo: " + record.inspect
    end
  	write_to_log(msg, record)
  end
  def before_destroy(record)
    write_to_log(User.current_user.login + " destruyo: " + record.inspect, record)
  end
end
