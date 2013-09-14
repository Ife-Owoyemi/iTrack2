ISwitched1::Application.routes.draw do
  get "users/new"

  get "static_pages/home"

  get "static_pages/help"
  get "gradprep/premed"
  get "static_pages/about"
  get "undergrad/majorsba" 
  get "undergrad/majorsbas"
  get "undergrad/majorsbs"
  get "undergrad/minors"
  get "users/edituser"
  get "users/edittrack"
  get "catalogs/catalog"
  root to: "users#show" # rooted to profile page
  match '/home', to: 'static_pages#home', :as => :home

  match '/signup', to: 'users#new'
  match '/signin', to: 'sessions#new', :as => :signin
  match '/signout', to: 'sessions#destroy', via: :delete

  match '/catalog', to: 'catalogs#catalog'
  match '/help', to: 'static_pages#help'
  match '/about', to: 'static_pages#about'
  match '/contact', to: 'static_pages#contact'
  match '/majorsba', :to => 'undergrad#majorsba'  
  match '/majorsbas', :to => 'undergrad#majorsbas'
  match '/majorsbs', :to => 'undergrad#majorsbs'
  match '/minors', :to => 'undergrad#minors' 
  match '/premed', :to => 'gradprep#premed'

  match '/createCourseModalJson', :to => 'usercourses#createCourseModalJson'
  match '/createFromModal', :to => 'usercourses#createFromModal'
  match '/deleteUsercourseFromHome', :to => 'usercourses#deleteUsercourseFromHome'

  match '/undergrad/switchTabMajorsBa', :to => 'undergrad#switchTabMajorsBa'
  match '/undergrad/courseSearch', :to => 'undergrad#courseSearch'

  match '/uploadTranscript', :to => 'users#uploadTranscript'

  resources :users do
    member do
      get :following, :followers
    end
  end
  match '/users/search', :to => 'users#search'
  match '/users/search_by_achievement', :to => 'users#search_by_achievement'  
  resources :institutions
  resources :courses
  resources :sessions,      only: [:new, :create, :destroy]
  resources :microposts,    only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  resources :usercourses, only: [:create, :destroy, :update]
  resources :awards, only: [:create, :destroy, :update]
  resources :internships, only: [:create, :destroy, :update]
  resources :conferences, only: [:create, :destroy, :update]
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
