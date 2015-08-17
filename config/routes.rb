Rails.application.routes.draw do

  resources :comments
  resources :order_forms
  default_url_options  :host => CONFIG["Host"]
  root to: 'users#index'
  post   'login'   => 'users#logon'
  delete 'logout'  => 'users#logout'
  get	 'reset' => 'users#reset', as: :password_reset
  post	 'reset' => 'users#reset_confirm'
  get    'reset/:id/:activation' => 'users#reset_return', as: :send_password_reset
  patch   'reset/:id/:activation' => 'users#reset_return_confirm'
  get	 'users/:id/activate/:activation' => 'users#activate', as: :activate_user

  get	 'images/:id' =>  'images#show'
  get	 'images/:id/thumb/' =>  'images#thumb', as: :image_thumb

  get    'users/search'  => 'users#search', as: :search_user
  post   'users/search'  => 'users#search'

  resources :users
  
  get 'pools(/user/:user_id)' => 'pools#index' , as: :pools
  get "users/:id/workboard" => "kanban_lists#index", as: :workboard
  post "users/:id/workboard" => "kanban_lists#create"
  post "users/:id/workboard/:kanban_list_id" => "kanban_cards#create", as: :new_card
  patch "users/:id/workboard/:kanban_list_id/cards/:kanban_card_id" => "kanban_cards#update", as: :card
  resources :pools, except: :index
  resources :submissions
end
