Tutubnb2::Application.routes.draw do

  get "deal/new"

  match "deal/create" => "deal#create", :via => :post, :as => :deals

  get "deal/accept"

  get "deal/reject"

  get "deal/cancel"

  match  "/deal/:id" => "deal#show", :via => :get, :as => :deal

  get "user/edit"

  get "user/update"

  get "user/listings"

  get "user/trips"

  get "user/requests"

  match  "/addresses" => "address#create", :via => :post
  match  "/address/:id/edit" => "address#edit", :via => :get, :as => :edit_address
  match  "/address/new" => "address#new", :via => :get, :as => :new_address
  match  "/address/:id" => "address#show", :via => :get, :as => :address
  match  "/address/:id" => "address#update", :via => :put
  match  "/address/:id" => "address#destroy", :via => :delete
  

  match "/details" => "detail#create", :via => :post
  resources :detail, :controller => 'detail'


  match "/prices" => "price#create", :via => :post
  resources :price, :controller => 'price'


  match "/places" => "place#create", :via => :post
  resources :place, :controller => 'place'

  match "display/show" => "display#show", :via => :post, :as => :display_show
  match "display/show" => "display#show", :via => :get, :as => :display_show

  post "display/search"

  get "profile/login"

  get "profile/logout"

  get "profile/signup"

  get "profile/save"

  post "profile/save"

  #match "/profile/validate_user" => "profile#validate_user", as: "validate_user"
  post "profile/validate_user"

  

  #match "/places" => "place#create"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
