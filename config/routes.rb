Rails.application.routes.draw do

  default_url_options host: CONFIG[:host]

  root controller: :users, action: :index

  controller :application do
    get :static, path: "pages/:page_name"
  end

  controller :messages do
    get :index, path: "activity(/page/:page)", as: :messages
    get :create, path: "submission/:#{Submission.slug}(/reply/:message_#{Message.slug})", as: :new_comment
    patch :update, path: "comment/:#{Message.slug}", as: :update_comment
    delete :destroy, path: "comment/:#{Message.slug}", as: :destroy_comment
    #get "message_listener", to: "messages#listener", as: :listener
    get :poller, path: "message_poller", as: :poller
    post :annoucement, path: "announcements", as: :new_announcement
    # resources :messages, only: [:index], path: "conversations/(:recipient)", as: :pms
    # resources :messages, only: [:create], path: "conversations/(:recipient)", as: :pms
    # get :new, path: "reply/:message_id", as: :new_pm
  end

  controller :images do
    get :show, path: "image/:type(/:#{Image.slug})", as: :image
    get :download, path: "download/:#{Image.slug}", as: :download_image
  end

  controller :pools do
    get :index, path: "(:#{User.slug})/pools(/page/:page)", as: :pools
    post :create, path: "pools", as: :new_pool
    patch :update, path: "pool/:#{Pool.slug}/update", as: :update_pool
    delete :destroy, path: "pool/:#{Pool.slug}/destroy", as: :destroy_pool
    get :gallery, path: ":#{User.slug}/gallery", as: :gallery
  end

  controller :submissions do
    get :index, path: "(pool/:pool_#{Pool.slug}/)submissions(/page/:page)", as: :submissions
    get :show, path: "(pool/:pool_#{Pool.slug}/)submission/:#{Submission.slug}", as: :submission
    post :create, path: "(pool/:pool_#{Pool.slug}/)submissions", as: :new_submission
    patch :update, path: "submission/:#{Submission.slug}/update", as: :update_submission
    delete :destroy, path: "submission/:#{Submission.slug}/destroy", as: :destroy_submission
    get :fav, path: "submisison/:#{Submission.slug}/fav", as: :fav_submission
  end

  controller :order_forms do
    get :index, path: "(:#{User.slug}/)order_forms(/page/:page)", as: :order_forms
    post :create, path: "order_forms", as: :new_order_form
    get :show, path: "order_form/:#{OrderForm.slug}", as: :order_form
    patch :update, path: "order_form/:#{OrderForm.slug}/update", as: :update_order_form
    delete :destroy, path: "order_form/:#{OrderForm.slug}/destroy", as: :destroy_order_form
    get :set_default, path: ":#{User.slug}/order_forms/:#{OrderForm.slug}/default", as: :default_order_form
  end

  controller :orders do
    get :index, path: "orders(/page/:page)", as: :orders
    post :create, path: "orders/:#{OrderForm.slug}", as: :place_order
    get :new, path: "order/:#{OrderForm.slug}/new", as: :new_order
    get :show, path: "order/:#{Order.slug}", as: :show_order
    patch :accept, path: "order/:#{Order.slug}/accept", as: :accept_order
    patch :reject, path: "order/:#{Order.slug}/reject", as: :reject_order
  end

  controller :cards do
    get :index, path: ":#{User.slug}/workboard", as: :cards
    patch :create, path: ":#{User.slug}/workboard/:#{Card.slug}", as: :new_card
    patch :update, path: ":#{User.slug}/workboard/:#{Card.slug}/update", as: :update_card
    delete :destroy, path: ":#{User.slug}/workboard/:#{Card.slug}/destroy", as: :destroy_card
    patch :reorder, path: ":#{User.slug}/workboard/reorder", as: :reorder_cards
  end

  controller :users do
    get :index, path: "users(/page/:page)", as: :users
    get :new, path: "register", as: :register
    post :create, path: "users", as: :new_user
    patch :update, path: ":#{User.slug}/update", as: :update_user
    post :log_in, path: "log_in", as: :log_in
    delete :log_out, path: "log_out", as: :log_out
    get :send_reset, path: ":#{User.slug}/send_reset", as: :send_password_reset
    post :reset, path: ":#{User.slug}/reset", as: :password_reset
    get :send_activation, path: ":#{User.slug}/send_activation", as: :send_user_activation
    post :activate, path: ":#{User.slug}/activate", as: :activate_user
    get :watch, path: ":#{User.slug}/watch", as: :watch_user
    get :dashboard, path: ":#{User.slug}/settings", as: :dashboard
  end

  controller :users do
    get :show, path: ":#{User.slug}", as: :user
  end

end