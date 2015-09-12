Rails.application.routes.draw do
  default_url_options host: CONFIG[:host]

  root controller: :users, action: :index

  controller :application do
    get :static, path: "pages/:page_name"
  end

  controller :images do
    get "image/:type(/:#{Upload.slug})", to: "images#show", as: :image
    get "download/:#{Upload.slug}", to: "images#download", as: :download
  end

  resources :pools, only: [:index], path: "(:#{User.slug})/pools"
  resources :pools, only: [:create]
  resources :pools, except: [:index, :create, :edit]
  resources :submissions, except: [:edit]

  scope path: "submission/:submission_#{Submission.slug}" do
    resources :messages, only: [:create], path: "comments", as: :comments
    resources :messages, only: [:new], path: "reply/:recipient_id", as: :comments
    resources :messages, only: [:update, :destroy], path: "comments", as: :comments
  end

  scope path: ":#{User.slug}" do
    scope path: "workboard" do
      resources :cards, only: [:create, :index], path: ""
      resources :cards, only: [:update, :destroy], path: ""
    end
    resources :messages, only: [:index]
    resources :messages, only: [:index], path: "(:recipient)/conversations", as: :pms
    resources :messages, only: [:create], path: ":recipient/conversations", as: :pms
    controller :pools do
      get :show, path: "gallery", as: :gallery
    end
  end

  controller :users do
    post :resend_activation_email, as: :resend
    post :index, as: :search
    post :log_in
    delete :log_out
    get :new, path: "register", as: :register
    scope path: "reset" do
      get :reset, as: :password_reset
      post :reset_confirm, as: :reset
      scope path: ":#{User.slug}" do
        get :reset_return, path: ":activation", as: :send_password_reset
        patch :reset_return_confirm, path: ":activation"
      end
    end
    resources :users, except: [:new, :edit], param: User.slug, path: "" do
      member do
        get :watch
        get :activate, path: "activate/:activation", as: :activate
        resources :orders
      end
    end
  end
end
