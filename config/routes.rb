Sbcx::Application.routes.draw do


  #resource :profile, controller: 'registrations', only: [:show]

  resources :my_users, only: [:new, :create, :edit, :show, :index, :update], controller: 'my_users'


  resources :service_calls, only: [:new, :create, :edit, :show, :index, :update] do
    get :autocomplete_customer_name, :on => :collection
    get :autocomplete_material_name, :on => :collection
    resources :boms do
      get :autocomplete_material_name, :on => :collection
    end
  end

  resources :agreements, only: [:new, :create, :edit, :show, :index]

  resources :providers, only: [:new, :create, :edit, :show, :index, :update]
  resources :subcontractors, only: [:new, :create, :edit, :show, :index, :update]
  resources :affiliates, only: [:new, :create, :edit, :show, :index, :update], controller: 'affiliates'
  resources :notifications, only: [:show, :index, :update, :destroy]


  root to: 'static_pages#index'

  # overriding the devise registration controller
  devise_for :users, :controllers => { :registrations => "registrations", :passwords => "passwords", :sessions => "sessions" }

  devise_scope :user do
    match "/profile" => "registrations#show"
  end


  get '/region_select/subregion_options' => 'region_select#subregion_options', as: :region_select

  resources :organizations, only: [:new, :create, :edit, :show, :index, :update]
  resources :customers, only: [:new, :create, :edit, :show, :index, :update]
  resources :materials, only: [:new, :create, :edit, :show, :index, :update] do
    get :autocomplete_material_name, :on => :collection
  end

  match 'welcome' => 'static_pages#welcome', :as => :user_root
  match 'calendar' => 'static_pages#calendar', :as => :calendar


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
