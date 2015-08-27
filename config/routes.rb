Rails.application.routes.draw do

  default_url_options host: CONFIG[:host]

  root to: "users#index"

  get  "reset" => "users#reset", as: :password_reset
  post   "reset" => "users#reset_confirm"
  get    "reset/:#{User.slug}/:activation" => "users#reset_return", as: :send_password_reset
  patch   "reset/:#{User.slug}/:activation" => "users#reset_return_confirm"

  post :log_in, to: "users#log_in"
  get :log_out, to: "users#log_out"
  get :register, to: "users#new"

  get "search"  => "users#search", as: :search_user
  post "search"  => "users#search"

  get ":#{User.slug}/gallery", to: "pools#show", as: :gallery

  get "image/:type(/:id)", to: "images#show", as: :image

  get "(:#{User.slug})/pools" => "pools#index" , as: :pools
  resources :pools, only: [:create, :update, :destroy, :show]
  resources :submissions

  resources :users, except: [:new, :edit], param: User.slug, path: "" do
    member do
      get :watch
      get "/activate/:activation" => "users#activate", as: :activate_user
      post "/avatar" => "images#create", as: :new_avatar
      get "/workboard" => "kanban_lists#index", as: :workboard
      post "/workboard" => "kanban_lists#create", as: :new_list
      patch "/workboard/:kanban_list_id" => "kanban_lists#update", as: :list
      post "/workboard/:kanban_list_id" => "kanban_cards#create", as: :new_card
      patch "/workboard/:kanban_list_id/cards/:kanban_card_id" => "kanban_cards#update", as: :card

      resources :comments, only: [:create, :update, :destroy]
      resources :order_forms
    end
  end
end
