Rails.application.routes.draw do
  default_url_options host: CONFIG[:host]

  root controller: :users, action: :index

  controller :application do
    get :static, path: "pages/:page_name"
  end

  controller :messages do
    #sse route
    #get "message_listener", to: "messages#listener", as: :listener
    #poller route
    get "message_poller", action: :poller, as: :poller
  end

  controller :images do
    get "image/:type(/:#{Image.slug})", to: "images#show", as: :image
    get "download/:#{Image.slug}", to: "images#download", as: :download
  end

  controller :attachments do
    resources :attachments, only: [:create, :destroy]
    get "attachments/new", action: :new, as: "new_attachment"
  end
  resources :pools, only: [:index], path: "(:#{User.slug})/pools"
  resources :pools, only: [:create], path: ":#{User.slug}/pools"
  resources :pools, only: [:show, :update, :destroy]

  scope path: "pools/:pool_#{Pool.slug}" do
    resources :submissions, except: [:new, :edit] do
      member do
        get :fav
      end
    end
  end

  controller :orders do
    resources :orders, only: [:create]
    get :place_order, path: "order/:#{OrderForm.slug}"
  end

  scope path: "submissions/:submission_#{Submission.slug}" do
    controller :messages do
      resources :messages, only: [:create], path: "comments", as: :comments
      get :new, path: "reply/:message_id", as: :new_comment
      resources :messages, only: [:update, :destroy], path: "comments", as: :comments
    end
  end

  scope path: ":#{User.slug}" do
    scope path: "dashboard" do
      controller :messages do
        post :create_annoucement, path: "announcements", as: :announcements
      end
    end
    scope path: "workboard" do
      controller :cards do
        get :index, path: "", as: :cards
        patch :reorder_cards, path: "reorder"
        patch :new_list, path: "new"
        patch :update_list, path: ":#{Card.slug}"
        delete :destroy_list, path: ":#{Card.slug}"
        patch :new_card, path: "new/:#{Card.slug}"
        patch :update_card, path: "card/:#{Card.slug}"
        delete :destroy_card, path: "card/:#{Card.slug}"
      end
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
    controller :order_forms do
      get :set_default, path: "order_forms/:#{OrderForm.slug}/default", as: :default_order_form
      resources :order_forms, only: [:create, :index, :edit, :update, :destroy]
    end
    controller :users do
      get :dashboard
      get :reset_return, path: ":activation", as: :send_password_reset
      patch :reset_return_confirm, path: ":activation"
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
    end
    resources :users, except: [:new, :edit], param: User.slug, path: "" do
      member do
        get :watch
        get :activate, path: "activate/:activation", as: :activate
      end
    end
  end
end
