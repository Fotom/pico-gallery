ActionController::Routing::Routes.draw do |map|
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
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.

  # for index page
  map.connect ':id', :controller => 'pictures', :action => 'index', :requirements => {:id => /\d*/}

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'

  # for will_paginate build beautiful url
  map.connect ':controller/:action/:id/page/:page'
  map.connect '/page/:page', :controller => 'pictures', :action => 'index', :requirements => {:page => /\d*/}

  # for admins
  map.admin   '/admin', :controller => 'common_admins'
  map.admins  '/admins', :controller => 'common_admins'
  map.namespace(:admins) do |admin|
    admin.resources :parts
    admin.resources :pictures
  end

  # for locales
  map.contact 'parts', :controller => 'parts', :action => 'index'
  map.contact 'pictures', :controller => 'pictures', :action => 'index'
  ActionController::Routing::Translator.i18n('en')

end
