Rails.application.routes.draw do

  default_url_options host: CONFIG[:host]

  root to: "users#index"

  post :log_in, to: "users#log_in"
  get :log_out, to: "users#log_out"
  get :register, to: "users#new"
  get User.slug.to_s+"/gallery", to: "pools#gallery", as: "gallery"

  get "image/:type(/:id)", to: "images#show", as: :image

  post User.slug.to_s+"/avatar" => "images#create", as: :new_avatar

  resources :comments
  resources :order_forms
  
  
  get	 "reset" => "users#reset", as: :password_reset
  post	 "reset" => "users#reset_confirm"
  get    "reset/:id/:activation" => "users#reset_return", as: :send_password_reset
  patch   "reset/:id/:activation" => "users#reset_return_confirm"
  get	User.slug.to_s+"/activate/:activation" => "users#activate", as: :activate_user

  

  get "search"  => "users#search", as: :search_user
  post "search"  => "users#search"

  
  
  #get "pools(/user/:user_id)" => "pools#index" , as: :pools
  get User.slug.to_s+"/workboard" => "kanban_lists#index", as: :workboard
  post User.slug.to_s+"/workboard" => "kanban_lists#create", as: :new_list
  patch User.slug.to_s+"/workboard/:kanban_list_id" => "kanban_lists#update", as: :list
  post User.slug.to_s+"/workboard/:kanban_list_id" => "kanban_cards#create", as: :new_card
  patch User.slug.to_s+"/workboard/:kanban_list_id/cards/:kanban_card_id" => "kanban_cards#update", as: :card
  resources :submissions

  resources :users, except: [:new, :edit], param: User.slug, path: "" do
    member do
      resources :pools, except: :edit
    end
  end
end
