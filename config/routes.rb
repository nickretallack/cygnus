Rails.application.routes.draw do

  default_url_options host: CONFIG[:host]

  root to: "users#index"

  get "pages/:page_name", to: "application#static_page", as: :static

  get  "reset" => "users#reset", as: :password_reset
  post   "reset" => "users#reset_confirm"
  get    "reset/:#{User.slug}/:activation" => "users#reset_return", as: :send_password_reset
  patch   "reset/:#{User.slug}/:activation" => "users#reset_return_confirm"

  post :log_in, to: "users#log_in"
  delete :log_out, to: "users#log_out"
  get :register, to: "users#new"

  get "search"  => "users#search", as: :search_user
  post "search"  => "users#search"

  get "image/:type(/:id)", to: "images#show", as: :image
  get "download/:id", to: "images#download", as: :download

  post ":#{User.slug}/avatar" => "images#create", as: :new_avatar
  get ":#{User.slug}/workboard" => "kanban_lists#index", as: :workboard
  post ":#{User.slug}/workboard" => "kanban_lists#create", as: :new_list
  patch ":#{User.slug}/workboard/:kanban_list_id" => "kanban_lists#update", as: :list
  post ":#{User.slug}/workboard/:kanban_list_id" => "kanban_cards#create", as: :new_card
  patch ":#{User.slug}/workboard/:kanban_list_id/cards/:kanban_card_id" => "kanban_cards#update", as: :card
  delete ":#{User.slug}/workboard/:kanban_list_id/cards/:kanban_card_id" => "kanban_cards#destroy", as: :destroy_card

  scope path: ":#{User.slug}" do
    controller :messages do
      resources :messages, only: [:index]
      scope path: "(:recipient)" do
        get :inbox, as: :inbox
        get :outbox, as: :outbox
      end
      scope path: ":recipient" do
        resources :messages, only: [:create], path: "pms", as: :pms
      end
      resources :messages, only: [:destroy], path: "pms", as: :pms
    end
    controller :pools do
      get :show, path: "gallery", as: :gallery
    end
  end

  scope path: "submission/:submission_#{Submission.slug}" do
    resources :messages, except: [:new, :edit, :show], path: "comments", as: :comments
    resources :messages, only: [:new], path: "reply/:recipient_id", as: :comments
  end

  resources :pools, only: [:index], path: "(:#{User.slug})/pools", as: :pools
  resources :pools, only: [:create], as: :pools
  resources :pools, except: [:index, :create, :edit]
  resources :submissions

  resources :users, except: [:new, :edit], param: User.slug, path: "" do
    member do
      get :watch
      get "/activate/:activation" => "users#activate", as: :activate
      resources :order_forms
    end
  end
end
