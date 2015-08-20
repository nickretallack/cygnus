Rails.application.routes.draw do

  default_url_options host: CONFIG[:host]

  root to: "users#index"

  post :log_in, to: "users#log_in"
  get :log_out, to: "users#log_out"
  get :register, to: "users#new"
  get ":name/gallery", to: "pools#gallery", as: "gallery"

  get "images/:type(/:id)", to: "images#show", as: :image

  resources :users, except: [:new, :edit], param: :name, path: "" do
    member do
      resources :pools, except: :edit
    end
  end

  resources :comments
  resources :order_forms
  
  
  get	 "reset" => "users#reset", as: :password_reset
  post	 "reset" => "users#reset_confirm"
  get    "reset/:id/:activation" => "users#reset_return", as: :send_password_reset
  patch   "reset/:id/:activation" => "users#reset_return_confirm"
  get	 "users/:id/activate/:activation" => "users#activate", as: :activate_user

  

  get    "users/search"  => "users#search", as: :search_user
  post   "users/search"  => "users#search"

  
  
  #get "pools(/user/:user_id)" => "pools#index" , as: :pools
  get ":name/workboard" => "kanban_lists#index", as: :workboard
  post ":name/workboard" => "kanban_lists#create", as: :new_list
  patch ":name/workboard/:kanban_list_id" => "kanban_lists#update", as: :list
  post ":name/workboard/:kanban_list_id" => "kanban_cards#create", as: :new_card
  patch ":name/workboard/:kanban_list_id/cards/:kanban_card_id" => "kanban_cards#update", as: :card
  resources :submissions
end
