class Cost < ActiveRecord::Base
    belongs_to :product
    belongs_to :order
    belongs_to :entity
    
    #################################################################################################
    # Removes cost objects that have been sold
    # And returns the total cost
    #################################################################################################
    def self.consume(product, quantity, site)
        puts "product=#{product.inspect}"
        puts "site=#{site.inspect}"
        puts "quantity=#{quantity.to_s}"
        cost = first(:conditions=>"product_id=#{product.id} AND entity_id=#{site.id}")
        total=0
        puts "cost=#{cost.inspect}"
        while quantity > 0 and cost
            puts "quantity=#{quantity.to_s}"
            puts "cost.quantity=#{cost.quantity.to_s}"
            amt = [quantity, cost.quantity].min
            puts "amt=#{amt.to_s}"
            quantity -= amt
            puts "cost.value=#{cost.value.to_s}"
            puts "total=#{total.to_s}"
            total += cost.value * amt
            puts "total=#{total.to_s}"
            if cost.quantity == amt
                cost.destroy
            else
                cost.update_attribute(:quantity, cost.quantity - amt)
            end
            cost = first(:conditions=>"product_id=#{product.id} AND entity_id=#{site.id}")
        end
        puts "total=#{total.to_s}"
        return total
    end # def self.consume(product, quantity, site)
    #################################################################################################
    # Removes cost objects that have been sold
    # And returns the total cost
    # This function grabs the last cost rather than the first, this is for returning purhcases
    #################################################################################################
    def self.consume_last(product, quantity, site)
        puts "product=#{product.inspect}"
        puts "site=#{site.inspect}"
        cost = last(:conditions=>"product_id=#{product.id} AND entity_id=#{site.id}")
        total=0
        puts "cost=#{cost.inspect}"
        while quantity > 0 and cost
            amt = [quantity, cost.quantity].min
            quantity -= amt
            total += cost.value * amt
            if cost.quantity == amt
                cost.destroy
            else
                cost.update_attribute(:quantity, cost.quantity - amt)
            end
            cost = last(:conditions=>"product_id=#{product.id} AND entity_id=#{site.id}")
        end
        return total
    end # def self.consume(product, quantity, site)
    #################################################################################################
    # 
    #################################################################################################
    def self.stock_value(product, site)
        return sum('value * quantity', :conditions=>"product_id=#{product.id} AND entity_id=#{site.id}")
    end # def stock_value()
    #################################################################################################
    # 
    #################################################################################################
    def self.quantity(product, site)
        return sum(:quantity, :conditions=>"product_id=#{product.id} AND entity_id=#{site.id}")
    end # def quantity()
    #################################################################################################
    # 
    #################################################################################################
    def self.ref(product, site)
        c = first(:conditions=>"product_id=#{product.id} AND entity_id=#{site.id}")
        return Order.find_by_id(c.order_id) if c
        return nil
    end # def self.ref(product, site)

end
