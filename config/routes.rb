Rails.application.routes.draw do

  # You can have the root of your site routed with "root"
  root 'users#index'

  get 'promos', to: 'promos#index'
  get 'promos/locations', to: 'branches#get_by_locations'
  get 'stores', to: 'stores#index'
  get 'stores/branches/:id', to: 'stores#get_branches'
  get 'users', to: 'users#index'
  get 'branches', to: 'branches#index'

  get 'promos/:id', to: 'promos#show'
  get 'stores/:id', to: 'stores#show'
  get 'users/:id', to: 'users#show'

  post 'stores', to: 'stores#create'
  post 'users', to: 'users#create'
  post 'promos', to: 'promos#create'
  post 'branches', to: 'branches#create'

  post 'redemptions/redeem', to: 'redemptions#redeem'

  post 'stores/login', to: 'stores#login'
  post 'users/login', to: 'users#login'

  post 'promo/now', to: 'redemptions#generate_code'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

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
