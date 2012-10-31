Tutubnb2::Application.routes.draw do

  # im get "authenticate/create"
  # im get "authenticate/index"
  # im delete "authenticate/destroy"

  resources :tags, :only => [:index]
  
  # im match '/auth/:provider/callback' => 'authenticate#create'

  resources :reviews, :only => [:new, :create]

  resources :deals, :only => [:index] do
    member do
      post :reply
      post :complete
    end
  end
  
  resources :places, :only => [] do
    resources :deals, :only => [:new, :create]
  end

  resources :places do
    member do
      post :activate
      post :operation
    end
  end

  resources :users do
    member do
      get :change_dp
      post :update_dp
      get :visits
      get :trips
      get :requests
      get :requested_trips
      post :wallet
      post :activate
      get :places
      get :change_password
      post :update_password
    end

    collection do
      get :forget_password
      get :authenticate
    end
  end

  resources :sessions, :only => [] do
    collection do
      get :login
      get :logout
      post :validate_user
    end
  end

  # #match "photo/delete/:id" => "photo#delete", :via => :delete, :as => :photo_delete

  # match "/deals/new/:place_id" => "deal#new", :via => :get, :as => :deal_new

  # match "/deals/create/:place_id" => "deal#create", :via => :post, :as => :deals

  # match "/deals/complete/:id" => "deal#complete", :via => :post, :as => :deal_complete

  # match "/deals/:id" => "deal#show", :via => :get, :as => :deal

  # match "/deal/reply/:perform/:id" => "deal#reply", :via => :get, :as => :deal_reply

  # resources :users do
  #   member do
  #     get :edit, :as => :edit
  #     get :change_dp, :as => :change_dp
  #     put :update
  #     put :update_dp
  #     get :show
  #     delete :destroy
  #     post :wallet, :as => :wallet
  #     get :visits, :as => :visits
  #     get :requests, :as => :requests
  #     get :requested_trips, :as => :requested_trips
  #     get :trips, :as => :trips
  #     get :change_password, :as => :change_password
  #     get :places, :as => :places
  #     put :update_password, :as => :update_password
  #     get :register_with_site, :as => :register_with_site
  #     put :update_information, :as => :update_information
  #   end
  # end

  # # match  "/user/:id/edit" => "user#edit", :via => :get, :as => :user_edit

  # # match  "/user/:id/change_dp" => "user#change_dp", :via => :get, :as => :user_change_dp

  # # match  "/user/:id" => "user#update", :via => :put

  # # match  "/user/:id" => "user#destroy", :via => :delete, :as => :user

  # # match  "/user/:id/update_dp" => "user#update_dp", :via => :put

  # # match  "/user/:id" => "user#show", :via => :get, :as => :user

  # # match  "/user/wallet/:id" => "user#wallet", :via => :post, :as => :user_wallet

  # match "/user/activate/:flag/:id" => "user#activate", :via => :get, :as => :user_activate  

  # match "/admin/user" => "display#user", :via => :get, :as => :admin_users

  # match "/admin/deals" => "display#deals", :via => :get, :as => :admin_deals

  # # match  "/user/visits/:id" => "user#visits", :via => :get, :as => :user_visits

  # # match  "/user/requests/:id" => "user#requests", :via => :get, :as => :user_requests

  # # match  "/user/requested_trips/:id" => "user#requested_trips", :via => :get, :as => :user_requested_trips

  # match  "/user/:id" => "user#destroy", :via => :delete, :as => :user

  # # match "/user/change_password/:id" => "user#change_password", :via => :get, :as => :user_change_password

  # # match "/user/places/:id" => "user#places", :via => :get, :as => :user_places

  # # match "/user/update_password/:id" => "user#update_password", :via => :put, :as => :user_update_password

  # # match  "/user/trips/:id" => "user#trips", :via => :get, :as => :user_trips  

  # match  "/addresses" => "address#create", :via => :post
  # match  "/address/:id/edit" => "address#edit", :via => :get, :as => :edit_address
  # match  "/address/new" => "address#new", :via => :get, :as => :new_address
  # match  "/address/:id" => "address#show", :via => :get, :as => :address
  # match  "/address/:id" => "address#update", :via => :put
  # match  "/address/:id" => "address#destroy", :via => :delete
  
  # match  "/photos" => "photo#save", :via => :post

  # match "/details" => "detail#create", :via => :post
  # resources :detail, :controller => 'detail'

  # match "/rules" => "rule#create", :via => :post
  # resources :rules, :controller => 'rule'

  # match "/reviews" => "review#create", :via => :post
  # resources :review, :controller => 'review'


  # match "/prices" => "price#create", :via => :post
  # resources :price, :controller => 'price'


  # match  "/place/activate/:flag/:id" => "place#activate", :via => :get, :as => :activate_place
  # match  "/place/operation/:flag/:id" => "place#operation", :via => :get, :as => :operation_place
  # match  "/place/:id" => "place#show", :via => :post, :as => :place
  # match "/places" => "place#create", :via => :post
  # resources :place, :controller => 'place'

  # match "display/show" => "display#show", :via => :post, :as => :display_show
  # match "display/show" => "display#show", :via => :get, :as => :display_show

  # post "display/search"

  # match "profile/authenticate" => "profile#authenticate", :via => :get, :as => :authenticate

  # resources :profile do
  #   collection do
  #     get :login, :as => :login
  #     get :logout, :as => :logout
  #     get :signup, :as => :signup
  #     post :save, :as => :save
  #     post :validate_user, :as => :validate_user
  #     post :send_activation_link, :as => :send_activation_link
  #     get :forget_password, :as => :forget_password
  #   end
  # end

  # match "/change_password" => "profile#change_password", :via => :get, :as => :change_password

  # match "/update_password/:id" => "profile#update_password", :via => :put, :as => :profile_update_password

  # get 'tag/index'

  # # post "profile/save"

  # # post "profile/validate_user"

  # # post "profile/send_activation_link"

  

  # #match "/places" => "place#create"

  # # The priority is based upon order of creation:
  # # first created -> highest priority.

  # # Sample of regular route:
  # #   match 'products/:id' => 'catalog#view'
  # # Keep in mind you can assign values other than :controller and :action

  # # Sample of named route:
  # #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # # This route can be invoked with purchase_url(:id => product.id)

  # # Sample resource route (maps HTTP verbs to controller actions automatically):
  # #   resources :products

  # # Sample resource route with options:
  # #   resources :products do
  # #     member do
  # #       get 'short'
  # #       post 'toggle'
  # #     end
  # #
  # #     collection do
  # #       get 'sold'
  # #     end
  # #   end

  # # Sample resource route with sub-resources:
  # #   resources :products do
  # #     resources :comments, :sales
  # #     resource :seller
  # #   end

  # # Sample resource route with more complex sub-resources
  # #   resources :products do
  # #     resources :comments
  # #     resources :sales do
  # #       get 'recent', :on => :collection
  # #     end
  # #   end

  # # Sample resource route within a namespace:
  # #   namespace :admin do
  # #     # Directs /admin/products/* to Admin::ProductsController
  # #     # (app/controllers/admin/products_controller.rb)
  # #     resources :products
  # #   end

  # # You can have the root of your site routed with "root"
  # # just remember to delete public/index.html.
   root :to => 'display#show'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
