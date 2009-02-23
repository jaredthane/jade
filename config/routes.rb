ActionController::Routing::Routes.draw do |map|
  map.resources :product_types
  map.resources :roles
  map.resources :serialized_products
  map.resources :users
  map.resource :session
  map.resources :users
  map.resource :session
  map.resources :product_categories
  map.resources :prices
	map.resources :discounts
	map.resources :combos

  #map.resources :entity_types
	map.my_clients 'entities/my_clients', :controller => 'entities', :action => 'my_clients'
  map.resources :entities
  map.connect 'vendors.js', :controller => 'entities', :entity_type => 'vendors', :format =>'js'
  map.vendors 'vendors/', :controller => 'entities', :entity_type => 'vendors'
  map.new_vendor 'vendors/new', :controller => 'entities', :entity_type => 'vendors', :action => 'new'
  map.end_users 'end_users/', :controller => 'entities', :entity_type => 'end_users'
  map.wholesale_clients 'wholesale_clients/', :controller => 'entities', :entity_type => 'wholesale_clients'
  map.connect 'clients.js', :controller => 'entities', :entity_type => 'clients', :format =>'js'
  map.clients 'clients/', :controller => 'entities', :entity_type => 'clients'
  map.new_client 'clients/new', :controller => 'entities', :entity_type => 'clients', :action => 'new'
  map.connect 'sites.js', :controller => 'entities', :entity_type => 'sites', :format =>'js'
  map.sites 'sites/', :controller => 'entities', :entity_type => 'sites'
  map.new_site 'sites/new', :controller => 'entities', :entity_type => 'sites', :action => 'new'
	map.birthdays 'birthdays', :controller => 'entities', :action => 'birthdays'
	
  map.connect 'entities/:id/movements', :controller => 'entities', :action => 'movements'
  map.connect 'entities/:id/products', :controller => 'entities', :action => 'products'
  
  #map.connect 'locations/:id/sales', :controller => 'entities', :order_type => 'sales', :action => 'movements'
  #map.connect 'locations/:id/purchases', :controller => 'entities', :order_type => 'purchases', :action => 'movements'
  #map.connect 'locations/:id/movements', :controller => 'entities', :order_type => 'all', :action => 'movements'
  #map.connect 'locations/:id/products', :controller => 'entities', :action => 'products'
  #map.edit_prices 'products/edit_prices', :controller => 'products', :action => 'edit_prices'
  #map.update_prices 'products/update_prices', :controller => 'products', :action => 'update_prices'
  map.recommend 'inventories/recommend', :controller => 'inventories', :action => 'recommend'
  map.clear 'inventories/clear', :controller => 'inventories', :action => 'clear'
  map.resources :products, :collection => { :bulk_edit => :get, :bulk_update => :post }, :product_type => 'simple'
	map.connect 'allproducts.js', :controller => 'products', :scope => 'all', :format =>'js'
  map.show_batch 'orders/show_batch', :controller => 'orders', :action => 'show_batch'
  map.show_receipt 'orders/show_receipt/:id', :controller => 'orders', :action => 'show_receipt'
  map.create_batch 'orders/create_batch', :controller => 'orders', :action => 'create_batch'
	map.order_history 'orders/:id/history', :controller => 'orders', :action => 'show_history'
	map.connect 'lines/new', :controller => 'lines', :action => 'new', :format => 'js'
  map.resources :lines
	map.resources :inventories
	
  map.resources :users
  
  map.resources :units
    
  map.resources :payments
  
  map.resources :movements
  map.resources :warranties
  map.resources :services

	map.resources :requirements
  map.resources :orders
  map.connect 	'purchases/new', :controller => 'orders', :action => 'new', :order_type => 'purchases'
  map.connect 	'sales/new', :controller => 'orders', :action => 'new', :order_type => 'sales'
  map.connect 	'internal/new', :controller => 'orders', :action => 'new', :order_type => 'internal'
  map.purchases 'purchases/', :controller => 'orders', :order_type => 'purchases'
  map.internal 'internal/', :controller => 'orders', :order_type => 'internal'
  map.sales 'sales/', :controller => 'orders', :order_type => 'sales'

	map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
	map.signup '/signup', :controller => 'users', :action => 'new'
	map.login '/login', :controller => 'sessions', :action => 'new'
	map.logout '/logout', :controller => 'sessions', :action => 'destroy'
	map.reject '/reject', :controller => 'sessions', :action => 'reject'

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "products"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
