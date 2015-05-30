Rails.application.routes.draw do
  
  resources :client_bugs

  resources :dynamic_iaps

  resources :friend_requests

  resources :club_configs

  resources :clubs

  devise_for :users
  get "utility/show_api_key", to: "utility#show_api_key", as: "show_api_key"
  post "utility/generate_api_key", to: "utility#generate_api_key", as: "generate_api_key"

  namespace :api do
    namespace :v1 do
      resources :game_requests
      resources :games do
        get :player_list
      end
      resources :client_bugs
      resources :dynamic_iaps
      resources :club_configs
      resources :users
      resources :friend_requests
      resources :gift_requests
      resources :sessions, only: [:create, :destroy]
      resources :clubs
      resources :users do
        member do
          get :friend_request_sent
          get :my_friend_requests
          get :my_friends
          delete :delete_friend
          get :opponent_profile
          get :sent_gift
          get :received_gift
          get :ask_for_gift_to
          get :ask_for_gift_by
        end
      end
    end
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

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
  

  resources :utility do
    collection do
      get :sync_data
      get :flush_data
    end
  end
end
