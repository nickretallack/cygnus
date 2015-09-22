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
  resources :submissions, except: [:edit] do
    member do
      get :fav
    end
  end

  scope path: "submission/:submission_#{Submission.slug}" do
    controller :messages do
      resources :messages, only: [:create], path: "comments", as: :comments
      get :new, path: "reply/:message_id", as: :new_comment
      resources :messages, only: [:update, :destroy], path: "comments", as: :comments
    end
  end

  scope path: ":#{User.slug}" do
    scope path: "workboard" do
      resources :cards, only: [:index], path: ""
      resources :cards, only: [:update, :destroy], path: ""
    end
    controller :messages do
      resources :messages, only: [:index], path: "conversations/(:recipient)", as: :pms
      resources :messages, only: [:create], path: "conversations/(:recipient)", as: :pms
      get :new, path: "reply/:message_id", as: :new_pm
      resources :messages, only: [:index], path: "activity"
    end
    controller :pools do
      get :show, path: "gallery", as: :gallery
    end
  end

  controller :users do
    post :resend_activation_email, as: :resend
    post :index, path: "search", as: :search
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
        resources :order_forms
      end
    end
  end
end
