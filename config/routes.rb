Rails.application.routes.draw do
    resources :products, except: [:destroy]
    get '/products/:id/destroy' => 'products#destroy', as: :destroy_product

    get '/signup' => 'users#new', as: :new_user
    post '/signup' => 'users#create', as: :create_user
    get '/user/edit' => 'users#edit', as: :edit_user
    patch '/user/edit' => 'users#update', as: :update_user
    get '/user/delete' => 'users#destroy', as: :destroy_user

    get '/login' => 'sessions#new', as: :new_session
    post '/login' => 'sessions#create', as: :create_session
    get '/logout' => 'sessions#destroy', as: :destroy_session

    get '/basket' => 'basket#show', as: :basket
    post '/basket/add' => 'basket#add', as: :add_to_basket
    post '/basket/remove' => 'basket#remove', as: :remove_from_basket
    get '/basket/clear' => 'basket#clear', as: :clear_basket
    post '/basket/order' => 'basket#order', as: :basket_order

    root to: 'pages#home'
    # The priority is based upon order of creation: first created -> highest priority.
    # See how all your routes lay out with "rake routes".

    # You can have the root of your site routed with "root"
    # root 'welcome#index'

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
