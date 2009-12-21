ActionController::Routing::Routes.draw do |map|
  map.resources :product_types
  map.resources :roles
  map.resources :serialized_products
  map.resource :session
  map.resources :payments
  map.show_barcode 'products/:id/barcode', :controller => 'products', :action => 'show_barcode'
  map.destroy_payment 'payments/:id/destroy', :controller => 'payments', :action => 'destroy'
  map.create_nul_receipt_number 'orders/create_nul_number', :controller => 'orders', :action => 'create_nul_number'
  map.new_nul_receipt_number 'orders/new_nul_number', :controller => 'orders', :action => 'new_nul_number'
#  map.process_subscriptions 'receipts/process_subscriptions', :controller => 'receipts', :action => 'process_subscriptions'
  map.new_balance_transfer 'accounts/:id/new_balance_transfer', :controller => 'accounts', :action => 'new_balance_transfer'
  map.recount_balances 'accounts/:id/recount', :controller => 'accounts', :action => 'recount'
  map.create_balance_transfer 'accounts/:id/create_balance_transfer', :controller => 'accounts', :action => 'create_balance_transfer'
  map.preview_process 'subscriptions/preview_process', :controller => 'subscriptions', :action => 'preview_process'
  map.attachment 'orders/attachment', :controller => 'orders', :action => 'attachment'
  map.resources :product_categories
  map.resources :accounts
  map.price_list 'products/price_list', :controller => 'products', :action => 'price_list', :format =>'pdf'
  map.resources :prices
  map.update_scope 'users/update_scope', :controller => 'users', :action => 'update_scope'
  map.sales_representatives_report 'sales_representatives/report', :controller => 'sales_representatives', :action => 'report'
  map.resources :sales_representatives
  map.new_history 'entities/:id/new_history', :controller => 'entities', :action => 'new_history', :filter => ' tipo:cliente'
  map.create_history 'entities/:id/create_history', :controller => 'entities', :action => 'create_history', :filter => ' tipo:cliente'
  map.new_post 'posts/new', :controller => 'posts', :action => 'new', :format =>'js'
  map.resources :trans
#  map.consumidor_final_today 'receipts/concat_pdf', :controller => 'receipts', :action => 'concat_pdf', :entity_type_id =>2, :format =>'pdf'
#  map.credito_fiscal_today 'receipts/concat_pdf', :controller => 'receipts', :action => 'concat_pdf', :entity_type_id =>5, :format =>'pdf'
  map.pay_off 'orders/:id/pay_off', :controller => 'orders', :action => 'pay_off'
  map.todays_sales 'orders/todays_sales/', :controller => 'orders', :action => 'show_todays_sales'
#  map.receipts_report 'receipts/report', :controller => 'receipts', :action => 'report'
  map.payments_report 'payments/report', :controller => 'payments', :action => 'report'
  map.todays_accounting_report 'payments/todays_accounting_report', :controller => 'payments', :action => 'todays_accounting_report'
#  map.todays_receipts 'receipts/today/', :controller => 'receipts', :action => 'show_today'
#  map.receipts_list_to_print 'receipts/printable', :controller => 'receipts', :action => 'list_to_print'
#  map.unpaid_receipts 'receipts/unpaid/', :controller => 'receipts', :action => 'unpaid'
#  map.new_batch_receipts 'subscriptions/new_receipts', :controller => 'receipts', :action => 'new_batch'
#  map.create_batch_receipts 'subscriptions/create_receipts', :controller => 'receipts', :action => 'create_batch'
#  map.create_receipt 'receipts/:id/create', :controller => 'receipts', :action => 'create'
#  map.new_receipt 'receipts/:id/new', :controller => 'receipts', :action => 'new'
#  map.fast_process_subscriptions 'subscriptions/fast_process', :controller => 'subscriptions', :action => 'fast_process'
#  map.process_client 'clients/:client_id/process', :controller => 'receipts', :action => 'process_subscriptions'
#  map.resources :receipts
#  map.process_subscription 'subscriptions/:sub_id/process', :controller => 'receipts', :action => 'process_subscription'
  map.resources :subscriptions
	map.resources :discounts
	map.resources :combos
	map.erase_order 'orders/:id/erase', :controller => 'orders', :action => 'erase'
#	map.erase_receipt 'receipts/:id/erase', :controller => 'receipts', :action => 'erase'
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
#	map.show_receipts 'orders/:id/receipts', :controller => 'orders', :action => 'show_receipts'
	map.show_receipt 'orders/:id/receipt', :controller => 'orders', :action => 'show_receipt'
  map.show_batch 'orders/show_batch', :controller => 'orders', :action => 'show_batch'
  map.create_batch 'inventories/create_batch', :controller => 'inventories', :action => 'create_batch'
#  map.delete_order 'orders/delete', :controller => 'orders', :action => 'delete'
	map.order_history 'orders/:id/history', :controller => 'orders', :action => 'show_history'
#	map.order_payments 'orders/:id/payments', :controller => 'orders', :action => 'show_payments'
#	map.order_receipts 'orders/:id/receipts', :controller => 'orders', :action => 'show_receipts'
#	map.destroy_receipt 'receipt/:id/destroy', :controller => 'receipts', :action => 'destroy'
	map.connect 'lines/new', :controller => 'lines', :action => 'new', :format=>'js'
  map.resources :lines
	map.resources :inventories
	

  
  map.resources :units
    
  map.movements_for_product 'movements/:site/:id', :controller => 'movements', :action => 'for_product'
  map.resources :movements
  map.resources :warranties
  map.resources :services

	map.resources :requirements
  map.resources :orders
  
#	map.resources :sales, :controller=>'orders', :order_type_id => 1
#	map.resources :purchases, :controller=>'orders', :order_type_id => 2
#	map.resources :internals, :controller=>'orders', :order_type_id => 3
#	map.resources :transfers, :controller=>'orders', :order_type_id => 4
#	map.resources :counts, :controller=>'orders', :order_type_id => 5
  map.new_purchase 	'purchases/new', :controller => 'orders', :action => 'new', :order_type_id => 2
  map.new_sale 	'sales/new', :controller => 'orders', :action => 'new', :order_type_id => 1
  map.new_internal 	'internal/new', :controller => 'orders', :action => 'new', :order_type_id => 3
  map.purchases 'purchases/', :controller => 'orders', :action => 'index', :order_type_id => 2
  map.internals 'internals/', :controller => 'orders', :action => 'index', :order_type_id => 3
  map.transfers 'transfers/', :controller => 'orders', :action => 'index', :order_type_id => 4
  map.new_transfer 'transfer/new', :controller => 'orders', :action => 'new', :order_type_id => 4
  map.counts 'counts/', :controller => 'orders', :action => 'index', :order_type_id => 5
  map.new_count 	'count/new', :controller => 'orders', :action => 'new', :order_type_id => 5
	map.post_count 'count/:id/post', :controller => 'orders', :action => 'post'
  map.internals 'internals/', :controller => 'orders', :action => 'index', :order_type_id => 3
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
