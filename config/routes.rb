Rails.application.routes.draw do

  default_url_options host: CONFIG[:host]

  root to: "users#index"

  post :log_in, to: "users#logon"
  delete :log_out, to: "users#logout"

  get "images/:id/:type", to: "images#show", as: :image

  resources :comments
  resources :order_forms
  
  
  get	 "reset" => "users#reset", as: :password_reset
  post	 "reset" => "users#reset_confirm"
  get    "reset/:id/:activation" => "users#reset_return", as: :send_password_reset
  patch   "reset/:id/:activation" => "users#reset_return_confirm"
  get	 "users/:id/activate/:activation" => "users#activate", as: :activate_user

  

  get    "users/search"  => "users#search", as: :search_user
  post   "users/search"  => "users#search"

  resources :users
  
  get "pools(/user/:user_id)" => "pools#index" , as: :pools
  get "users/:id/workboard" => "kanban_lists#index", as: :workboard
  post "users/:id/workboard" => "kanban_lists#create", as: :new_list
  patch "users/:id/workboard/:kanban_list_id" => "kanban_lists#update", as: :list
  post "users/:id/workboard/:kanban_list_id" => "kanban_cards#create", as: :new_card
  patch "users/:id/workboard/:kanban_list_id/cards/:kanban_card_id" => "kanban_cards#update", as: :card
  resources :pools, except: :index
  resources :submissions
end
