Rails.application.routes.draw do

  get 'tools/' => 'tools#index', as: :tools
  post 'tools/checkin', as: :checkin_tool
  post 'tools/checkout', as: :checkout_tool
  get 'tools/borrow', as: :borrow_tool
  get 'tools/return', as: :return_tool
  get 'tools/print_form', as: :print_form_tool

  get 'groups/:id' => 'groups#show', as: :group

  get 'ticketwiz/topic', as: 'wiz_topic'
  get 'ticketwiz/target', as: 'wiz_target'
  get 'ticketwiz/ticket', as: 'wiz_ticket'
  post 'ticketwiz/submit', as: 'wiz_submit'

  get 'users/:id' => 'users#show', as: :user
  post 'users/assign', as: :assign_user

  ['category', 'manufacturer', 'asset', 'listable', 'user', 'group', 'building', 'service', 'room', 'model', 'stn'].each do |l|
    get "typeahead/#{l.pluralize}/:query" => "typeahead##{l.pluralize}"
    get "typeahead/#{l.pluralize}/" => "typeahead##{l.pluralize}"
  end

  post 'session/create', as: :login
  get 'session/destroy', as: :logout
  get '/flash' => 'session#flashtest', as: :flash

  resources :subscriptions
  resources :services do
    post 'poke', on: :member
  end
  resources :assets do
    post 'reassign', on: :member
    get 'ping', on: :member
  end
  resources :consumables
  resources :models
  resources :buildings do
    get 'users', on: :member
    resources :rooms
  end
  resources :tickets do
    post 'attach', on: :member
    post 'step', on: :member
  end
  resources :topics do
    get 'permissions', on: :member
    post 'allow', on: :member
    get 'deny', on: :member
  end

  post '/jump' => 'dashboard#jump', as: :jump

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'dashboard#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
