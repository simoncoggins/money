ActionController::Routing::Routes.draw do |map|
  map.resources :tags

map.data 'data/bytag/:period.json', :controller => 'data', :action => 'bytag'

  # The priority is based upon order of creation: first created -> highest priority.
map.transactions     'transactions',          :controller => 'transactions'
map.new_transaction  'transactions/new',      :controller => 'transactions', :action => 'new'
map.edit_transaction 'transaction/edit/:id',  :controller => 'transactions', :action => 'edit'
map.destroy_transaction 'transaction/destroy/:id', :controller => 'transactions', :action => 'destroy'
map.transaction      'transactions/show/:id', :controller => 'transactions', :action => 'show'


map.patterns     'patterns',          :controller => 'patterns'
map.new_pattern  'patterns/new',      :controller => 'patterns', :action => 'new'
map.edit_pattern 'pattern/edit/:id',  :controller => 'patterns', :action => 'edit'
map.destroy_pattern 'pattern/destroy/:id', :controller => 'patterns', :action => 'destroy'
map.pattern      'patterns/show/:id', :controller => 'patterns', :action => 'show'

map.view 'view', :controller => 'view'
map.other_view 'view/other', :controller => 'view', :action => 'other'
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
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
