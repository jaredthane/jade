namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    require 'populator'
    require 'faker'
    
    [Entity, Product, Order, User, Line, Payment, Movement].each(&:delete_all)
    Entity.populate 4 do |location|
    	location.name = Faker::Company.name
    	location.entity_type_id = 3
   	end
    Entity.populate 20 do |client|
    	client.name = Faker::Company.name
    	client.entity_type_id = 2
    end
    Entity.populate 20 do |vendor|
      vendor.name = Faker::Company.name
      vendor.entity_type_id = 1
      Product.populate 5..15 do |product|
        product.vendor_id = vendor.id
        product.name = Populator.words(1..2).titleize
        product.description = Populator.sentences(2..10)
        product.price = [34.99, 19.95, 99.63, 35.75, 63.50, 12.99, 89.99]
        product.cost = [34.99, 19.95, 99.63, 35.75, 63.50, 12.99, 89.99]
        product.order = 0
        product.upc = 100000000..999999999
        product.unit_id = 1..4
        product.location = 1..4
        product.min = 1..100
        product.max = 1..100
        product.serialized = 0
        product.created_at = 2.years.ago..Time.now
        Movement.populate 1..10 do |movement|
        	movement.entity_id = 1..4
        	movement.product_id = product.id
        	movement.quantity = 1..100
        	movement.movement_type_id = 1
        	movement.user_id = 1..5
        	movement.order_id = 1005..1012
        	movement.created_at = 2.years.ago..Time.now
        end
      end
      Product.populate 5..15 do |product|
        product.vendor_id = vendor.id
        product.name = Populator.words(1..2).titleize
        product.description = Populator.sentences(2..10)
        product.price = [34.99, 19.95, 99.63, 35.75, 63.50, 12.99, 89.99]
        product.cost = [34.99, 19.95, 99.63, 35.75, 63.50, 12.99, 89.99]
        product.order = 0
        product.upc = 100000000..999999999
        product.unit_id = 1..4
        product.location = 1..4
        product.min = 1..100
        product.max = 1..100
        product.created_at = 2.years.ago..Time.now
        product.serialized = 1
        SerializedProduct.populate 1 do |serial|
        	product.created_at = 2.years.ago..Time.now
        	serial.product_id = product.id
        	serial.serial_number = 100000..999999
		      Movement.populate 1..40 do |movement|
		      	movement.entity_id = 1..4
		      	movement.product_id = product.id
		      	movement.quantity = 1
		      	movement.movement_type_id = 1
		      	movement.user_id = 1..5
		      	movement.order_id = 1005..1012
		      	movement.created_at = 2.years.ago..Time.now
		      	movement.serialized_product_id = serial.id
		      end 
        end
      end
    end
    User.populate 5 do |user|
    	user.login = Faker::Name.name
    	user.location_id = 1..4
    end
    Order.populate 1 do |sale|
    	sale.client_id = 5..24
    	sale.vendor_id = 1..4
    	sale.id = 1003
    	sale.created_at = 2.years.ago..Time.now
    	sale.user_id = 1..5
    	Line.populate 1..10 do |line|
    		line.product_id=1..200
    		line.quantity = 1..100
    		line.price = [34.99, 19.95, 99.63, 35.75, 63.50, 12.99, 89.99]
    		line.order_id = sale.id
    	end
    end
    Order.populate 10..20 do |purchase|
    	purchase.client_id = 1..4
    	purchase.vendor_id = 25..40
    	purchase.created_at = 2.years.ago..Time.now
    	purchase.user_id = 1..5
    	Line.populate 1..10 do |line|
    		line.product_id=1..200
    		line.quantity = 1..100
    		line.price = [34.99, 19.95, 99.63, 35.75, 63.50, 12.99, 89.99]
    		line.order_id = purchase.id
    	end
    end
    Order.populate 10..20 do |sale|
    	sale.client_id = 5..24
    	sale.vendor_id = 1..4
    	sale.created_at = 2.years.ago..Time.now
    	sale.user_id = 1..5
    	Line.populate 1..10 do |line|
    		line.product_id=1..200
    		line.quantity = 1..100
    		line.price = [34.99, 19.95, 99.63, 35.75, 63.50, 12.99, 89.99]
    		line.order_id = sale.id
    	end
    end
  end
end
