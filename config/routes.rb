Sbcx::Application.routes.draw do

  resources :projects do
    resources :invoices
  end

  namespace :api do
    namespace :v1 do
      resources :events, only: [:show, :index]
      devise_scope :user do
        match '/sign_in' => 'sessions#create', :via => :post
        match '/sign_out' => 'sessions#destroy', :via => :delete
      end
      resources :service_calls
    end
  end

  resources :events, only: [:show, :index]

  resources :support_tickets
  resources :comments, :only => [:create, :destroy]


  resources :receipts, only: [:show]

  devise_for :admin_users, ActiveAdmin::Devise.config
  root to: 'static_pages#index'


  resource :job_imports, only: [:new, :create]
  resources :invites
  resource :settings, only: [:show, :edit, :update]
  resources :invoices, only: [:new, :create, :show, :index], controller: 'invoices'

                                                                                # for rails4 unmark the 'via:' part
  match '(errors)/:status', to: 'errors#show', constraints: { status: /\d{3}/ } # via: :all

  resource :calendar, only: :show
  resources :appointments

  resources :accounting_entries

  #resource :profile, controller: 'registrations', only: [:show]

  resources :my_users, only: [:new, :create, :edit, :show, :index, :update], controller: 'my_users'


  resources :service_calls, only: [:new, :create, :edit, :show, :index, :update] do
    get :autocomplete_customer_name, :on => :collection
    get :autocomplete_material_name, :on => :collection
    resources :invoices
    resources :boms do
      get :autocomplete_material_name, :on => :collection
    end
  end

  resources :my_service_calls, controller: :service_calls
  resources :transferred_service_calls, controller: :service_calls
  resources :subcon_service_calls, controller: :service_calls
  resources :broker_service_calls, controller: :service_calls

  resources :agreements, only: [:new, :create, :edit, :show, :index, :update] do
    resources :posting_rules
    resources :payments
  end

  resources :providers, only: [:new, :create, :edit, :index, :update]
  resources :providers, only: :show, :controller => 'affiliates'
  resources :subcontractors, only: [:new, :create, :edit, :index, :update]
  resources :subcontractors, only: :show, :controller => 'affiliates'
  resources :affiliates, only: [:new, :create, :edit, :show, :index, :update], controller: 'affiliates'
  resources :notifications, only: [:show, :index, :update, :destroy]


  # overriding the devise registration controller
  devise_for :users, :controllers => { :registrations => "registrations", :passwords => "passwords", :sessions => "sessions" }
  ActiveAdmin.routes(self)

  devise_scope :user do
    match "/profile" => "registrations#show"
    match "/sign_up" => "registrations#new", as: :sign_up
  end


  get '/region_select/subregion_options' => 'region_select#subregion_options', as: :region_select
  get '/agreements/agreement_roles' => 'agreements#agreement_roles', as: :agreement_roles


  resources :organizations, only: [:new, :create, :edit, :show, :index, :update]
  resources :customers, only: [:new, :create, :edit, :show, :index, :update]
  resources :materials, only: [:new, :create, :edit, :show, :index, :update, :destroy] do
    get :autocomplete_material_name, :on => :collection
  end

  match 'welcome' => 'static_pages#welcome', :as => :welcome
  match 'home' => 'static_pages#home', :as => :user_root
  match 'contact_us' => 'contact_us#new', as: :contact_us, via: :get
  match 'contact_us' => 'contact_us#create', as: :contact_us, via: :post

  ActiveAdmin.routes(self)

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
