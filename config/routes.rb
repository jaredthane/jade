ActionController::Routing::Routes.draw do |map|
  map.resources :product_types
  map.resources :roles
  map.resources :serialized_products
  map.resource :session
  map.new_balance_transfer 'accounts/:id/new_balance_transfer', :controller => 'accounts', :action => 'new_balance_transfer'
  map.create_balance_transfer 'accounts/:id/create_balance_transfer', :controller => 'accounts', :action => 'create_balance_transfer'
  map.preview_orders 'subscriptions/preview_orders', :controller => 'subscriptions', :action => 'preview_orders'
  map.attachment 'orders/attachment', :controller => 'orders', :action => 'attachment'
  map.resources :product_categories
  map.resources :accounts
  map.price_list 'products/price_list', :controller => 'products', :action => 'price_list', :format =>'pdf'
  map.resources :prices
  map.new_history 'entities/:id/new_history', :controller => 'entities', :action => 'new_history', :filter => ' tipo:cliente'
  map.create_history 'entities/:id/create_history', :controller => 'entities', :action => 'create_history', :filter => ' tipo:cliente'
  map.new_post 'posts/new', :controller => 'posts', :action => 'new', :format =>'js'
  map.new_transaction 'transactions/new', :controller => 'trans', :action => 'new'
  map.create_transaction 'transactions/create', :controller => 'trans', :action => 'create'
  map.consumidor_final_today 'receipts/concat_pdf', :controller => 'receipts', :action => 'concat_pdf', :entity_type_id =>2, :format =>'pdf'
  map.credito_fiscal_today 'receipts/concat_pdf', :controller => 'receipts', :action => 'concat_pdf', :entity_type_id =>5, :format =>'pdf'
  map.pay_off 'orders/:id/pay_off', :controller => 'orders', :action => 'pay_off'
  map.todays_sales 'orders/todays_sales/', :controller => 'orders', :action => 'show_todays_sales'
  map.todays_receipts_report 'receipts/todays_report', :controller => 'receipts', :action => 'todays_receipts_report'
  map.todays_receipts 'receipts/today/', :controller => 'receipts', :action => 'show_today'
  map.unpaid_receipts 'receipts/unpaid/', :controller => 'receipts', :action => 'unpaid'
  map.new_batch_receipts 'subscriptions/new_receipts', :controller => 'receipts', :action => 'new_batch'
  map.create_batch_receipts 'subscriptions/create_receipts', :controller => 'receipts', :action => 'create_batch'
  map.create_receipt 'receipts/:id/create', :controller => 'receipts', :action => 'create'
  map.receipt 'receipts/:id/', :controller => 'receipts', :action => 'show'
  map.new_receipt 'receipts/:id/new', :controller => 'receipts', :action => 'new'
  map.process_subscriptions 'subscriptions/process', :controller => 'subscriptions', :action => 'process_all'
  map.process_subscriptions 'subscriptions/fast_process', :controller => 'subscriptions', :action => 'fast_process'
  map.resources :subscriptions
	map.resources :discounts
	map.resources :combos
	map.post_physical_counts 'physical_counts/:id/post', :controller => 'physical_counts', :action => 'post'
	map.resources :physical_counts, :order_type_id => 5
	map.new_user_role 'user/new_role', :controller => 'users', :action => 'new_role', :format =>'js'
	map.my_clients 'entities/my_clients', :controller => 'entities', :action => 'my_clients', :filter => ' tipo:cliente'
	map.my_end_users 'entities/my_end_users', :controller => 'entities', :action => 'my_clients', :filter => ' tipo:consumidor'
	map.my_credito_fiscal 'entities/my_credito_fiscal', :controller => 'entities', :action => 'my_credito_fiscal', :filter => ' tipo:credito'
  map.resources :entities
  map.connect 'vendors.js', :controller => 'entities', :entity_type => 'vendors', :format =>'js', :filter => ' tipo:vendor'
  map.vendors 'vendors/', :controller => 'entities', :entity_type => 'vendors', :filter => ' tipo:vendor'
  map.new_vendor 'vendors/new', :controller => 'entities', :entity_type => 'vendors', :action => 'new', :filter => ' tipo:vendor'
  map.edit_vendor 'vendors/new', :controller => 'entities', :entity_type => 'vendors', :action => 'edit', :filter => ' tipo:vendor'
  map.end_users 'end_users/', :controller => 'entities', :entity_type => 'end_users', :filter => ' tipo:consumidor'
  map.wholesale_clients 'wholesale_clients/', :controller => 'entities', :entity_type => 'wholesale_clients', :filter => ' tipo:credito'
  map.connect 'clients.js', :controller => 'entities', :entity_type => 'clients', :format =>'js', :filter => ' tipo:cliente'
  map.clients 'clients/', :controller => 'entities', :entity_type => 'clients', :filter => ' tipo:cliente'
  map.new_client 'clients/new', :controller => 'entities', :entity_type => 'clients', :action => 'new', :filter => ' tipo:cliente'
  map.edit_client 'clients/new', :controller => 'entities', :entity_type => 'clients', :action => 'edit', :filter => ' tipo:cliente'
  map.connect 'sites.js', :controller => 'entities', :entity_type => 'sites', :format =>'js', :filter => ' tipo:site'
  map.sites 'sites/', :controller => 'entities', :entity_type => 'sites', :filter => ' tipo:site'
  map.new_site 'sites/new', :controller => 'entities', :entity_type => 'sites', :action => 'new', :filter => ' tipo:site'
  map.edit_site 'sites/new', :controller => 'entities', :entity_type => 'sites', :action => 'edit', :filter => ' tipo:site'
	map.birthdays 'birthdays', :controller => 'entities', :action => 'birthdays'
	
  map.connect 'entities/:id/movements', :controller => 'entities', :action => 'movements'
  map.connect 'entities/:id/products', :controller => 'entities', :action => 'products'
  
  map.recommend 'inventories/recommend', :controller => 'inventories', :action => 'recommend'
  map.clear 'inventories/clear', :controller => 'inventories', :action => 'clear'
  map.resources :products, :collection => { :bulk_edit => :get, :bulk_update => :post }, :product_type => 'simple'
	map.connect 'allproducts.js', :controller => 'products', :scope => 'all', :format =>'js'
	map.show_receipts 'orders/:id/receipts', :controller => 'orders', :action => 'show_receipts'
  map.show_batch 'orders/show_batch', :controller => 'orders', :action => 'show_batch'
  map.create_batch 'orders/create_batch', :controller => 'orders', :action => 'create_batch'
  map.delete_order 'orders/delete', :controller => 'orders', :action => 'delete'
	map.order_history 'orders/:id/history', :controller => 'orders', :action => 'show_history'
	map.order_payments 'orders/:id/payments', :controller => 'orders', :action => 'show_payments'
	map.order_receipts 'orders/:id/receipts', :controller => 'orders', :action => 'show_receipts'
	map.connect 'lines/new', :controller => 'lines', :action => 'new', :format => 'js'
  map.resources :lines
	map.resources :inventories
	

  
  map.resources :units
    
  map.resources :payments
  map.movements_for_product 'movements/:site/:id', :controller => 'movements', :action => 'for_product'
  map.resources :movements
  map.resources :warranties
  map.resources :services

	map.resources :requirements
  map.resources :orders
  map.new_purchase 	'purchases/new', :controller => 'orders', :action => 'new', :order_type_id => 2
  map.new_sale 	'sales/new', :controller => 'orders', :action => 'new', :order_type_id => 1
  map.new_internal 	'internal/new', :controller => 'orders', :action => 'new', :order_type_id => 3
  map.purchases 'purchases/', :controller => 'orders', :action => 'index', :order_type_id => 2
  map.internal 'internal/', :controller => 'orders', :action => 'index', :order_type_id => 3
  map.sales 'sales/', :controller => 'orders', :action => 'index', :order_type_id => 1

	map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
	map.new_user '/users/new', :controller => 'users', :action => 'new'
	map.login '/login', :controller => 'sessions', :action => 'new'
	map.logout '/logout', :controller => 'sessions', :action => 'destroy'
	map.reject '/reject', :controller => 'sessions', :action => 'reject'
	map.me '/me', :controller => 'users', :action => 'show_me'
  map.resources :users
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
