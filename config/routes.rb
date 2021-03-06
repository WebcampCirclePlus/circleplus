Rails.application.routes.draw do
# USERS
 devise_scope :user do
    get '/logout', to: 'users/sessions#destroy', as: :logout
  end
devise_for :users, :controllers => {

    :registrations => 'users/registrations',
    :sessions => 'users/sessions',
    :passwords => 'users/passwords'
  }

  get 'items/search' => 'items#search'

  get 'items/search_result' => 'items#search_result'

  resources :users, only: [:edit, :update, :show] do
    resources :cart_items, only: [:update, :destroy]
    resources :orders, only: [:new, :create, :edit, :update]
  end
  resources :genres, only: [:show]
  resources :items, only: [:index, :show]  do
      resources :cart_items, only: [:create]
  end

 get '/' => 'items#index', as: 'top'
  get '/cart' => 'cart_items#index', as: 'cart'
  get '/thanks' => 'users#thanks'
patch '/users/:id/destroy'=> 'users#destroy_update', as: 'user_destroy'

# ADMINS
 devise_for :admins, only: [:sign_in, :sign_out, :session],
 :controllers => {
   :sessions => 'admins/sessions'
 }
 get '/admins/' => 'admins#top'

 namespace :admins do

   resources :orders, only: [:index, :update]
   resources :artists, only: [:new, :create]
   resources :users, only: [:index, :edit, :update, :show]
   resources :items, only: [:show, :create, :edit, :update] do
     resources :discs, only: [:create, :edit, :update, :destroy] do
       resources :songs, only: [:create, :destroy, :update]
     end
   end
 end
 namespace :admins do
   resources :artists, only: [:show] do
     resource :items, only: [:new]
   end
 end
 patch 'admins/items/:item_id/hidden' => 'admins/items#hidden', as: 'hidden_item'
 patch 'admins/items/:item_id/itemoshow' => 'admins/items#itemshow', as: 'show_item'
 patch 'admins/users/:id/destroy'=> 'admins/users#destroy_update', as: 'admins_destroy_user'
 patch 'admins/items/:id/manage' => 'admins/items#manage_stock' , as: 'stock'
 # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

