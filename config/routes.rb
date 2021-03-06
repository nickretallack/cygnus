Rails.application.routes.draw do

  default_url_options host: CONFIG[:host]

  root controller: :users, action: :index
    
  require 'sidekiq/web'
  mount Sidekiq::Web => 's/jobs', constraints: AdminConstraint.new

  controller :messages do
    get :new, path: "reply", as: :reply_template
    post :create_comment, path: "submission/:#{Submission.slug}(/reply/:reply_#{Message.slug})/comments", as: :new_comment
    get :index, path: ":#{User.slug}/conversations(/page/:page)", as: :pms
    get :index, path: ":#{User.slug}/conversations/reply/:reply_to_#{User.slug}", as: :pm_author
    post :create_pm, path: ":#{User.slug}/to/:reply_to_#{User.slug}/conversations", as: :new_pm
    post :create_pm, path: ":#{User.slug}/reply/:reply_#{Message.slug}/conversations", as: :reply_pm
    get :activity, path: ":#{User.slug}/activity(/page/:page)", as: :messages
    #get "message_listener", to: "messages#listener", as: :listener
    get :poller, path: "s/message_poller", as: :poller
    post :create_announcement, path: ":#{User.slug}/announcements", as: :new_announcement
  end

  controller :images do
    get :show, path: "s/image/:type(/:#{Image.slug}(/:adult))", as: :image
    get :download, path: "s/download/:#{Image.slug}", as: :download_image
  end

  controller :pools do
    get :index, path: "/s/pools(/page/:page)", as: :all_pools
    get :index, path: "(:#{User.slug})/pools(/page/:page)", as: :pools
    post :create, path: ":#{User.slug}/pools", as: :new_pool
    patch :update, path: "pool/:#{Pool.slug}/update", as: :update_pool
    delete :destroy, path: "pool/:#{Pool.slug}/destroy", as: :destroy_pool
    get :gallery, path: ":#{User.slug}/gallery", as: :gallery
    patch :set_default, path: "pool/:#{Pool.slug}/default", as: :default_pool
  end

  controller :submissions do
    get :index, path: "s/(pool/:pool_#{Pool.slug})/submissions(/page/:page)", as: :submissions
    get :show, path: "s/(pool/:pool_#{Pool.slug})/submission/:#{Submission.slug}", as: :submission
    post :create, path: "pool/:pool_#{Pool.slug}/submissions", as: :new_submission
    patch :update, path: "submission/:#{Submission.slug}/update", as: :update_submission
    delete :destroy, path: "submission/:#{Submission.slug}/destroy", as: :destroy_submission
    get :fav, path: "submission/:#{Submission.slug}/fav", as: :fav_submission
  end

  controller :order_forms do
    get :index, path: ":#{User.slug}/order_forms(/page/:page)", as: :order_forms
    post :create, path: ":#{User.slug}/order_forms", as: :new_order_form
    get :show, path: "s/order_form/:#{OrderForm.slug}", as: :order_form
    patch :update, path: "s/order_form/:#{OrderForm.slug}/update", as: :update_order_form
    delete :destroy, path: "s/order_form/:#{OrderForm.slug}/destroy", as: :destroy_order_form
    patch :set_default, path: "s/order_forms/:#{OrderForm.slug}/default", as: :default_order_form
  end

  controller :orders do
    get :index, path: ":#{User.slug}/orders(/page/:page)", as: :orders
    post :create, path: "orders/:#{OrderForm.slug}", as: :place_order
    get :new, path: "s/place_order/:#{OrderForm.slug}", as: :new_order
    get :show, path: "s/order/:#{Order.slug}", as: :order
    patch :accept, path: ":#{User.slug}/order/:#{Order.slug}/accept", as: :accept_order
    patch :reject, path: ":#{User.slug}/order/:#{Order.slug}/reject", as: :reject_order
  end

  controller :cards do
    get :index, path: ":#{User.slug}/workboard", as: :cards
    post :comment, path: ":#{User.slug}/workboard/:#{Card.slug}", as: :comment_card
    patch :create, path: ":#{User.slug}/workboard/:#{Card.slug}", as: :new_card
    patch :update, path: ":#{User.slug}/workboard/:#{Card.slug}/update", as: :update_card
    delete :destroy, path: ":#{User.slug}/workboard/:#{Card.slug}/destroy", as: :destroy_card
    patch :reorder, path: ":#{User.slug}/workboard/:#{Card.slug}/reorder", as: :reorder_cards
    get :history, path: ":#{User.slug}/workboard/:#{Card.slug}", as: :history_card

  end
  
  controller :requests do
    get :new, path: "s/request/new(/:breed)", as: :new_request, defaults: { breed: 'request' }
    get :request_bid, path: "s/request/bid/:bid", as: :request_bid
    get :accept, path: "s/request/:#{Request.slug}/accept/:bid", as: :accept_bid
    post :create, path: "s/requests", as: :create_request
    post :bid, path: "s/request/:#{Request.slug}/bid", as: :bids_path
    delete :destroy, path: "s/request/:#{Request.slug}", as: :destroy_request
    get :show, path: "s/request/:#{Request.slug}", as: :request
    get :index, path: "s/requests(/:breed)", as: :requests, defaults: { breed: 'request' }
  end

  controller :users do
    get :index, path: "(s/page/:page)", as: :users
    post :index, path: "", as: :search
    post :create, path: "users", as: :new_user
    patch :update, path: ":#{User.slug}/update", as: :update_user
    post :log_in, path: "s/log_in", as: :log_in
    delete :log_out, path: "s/log_out", as: :log_out
    get :request_reset, path: "s/reset", as: :request_reset
    get :reset, path: ":#{User.slug}/reset/:token", as: :reset
    post :send_reset, path: "send_reset", as: :send_reset
    post :update_password, path: ":#{User.slug}/update_password", as: :update_password
    get :activate, path: ":#{User.slug}/activate/:token", as: :activate
    post :send_activation, path: "send_activation", as: :send_activation
    get :watch, path: ":#{User.slug}/watch", as: :watch_user
    get :dashboard, path: ":#{User.slug}/settings", as: :dashboard
    delete :destroy_attachment, path: ":#{User.slug}/attachment", as: :destroy_attachment
    delete :destroy, path: "destroy", as: :destroy_user
  end
  
  controller :pages do
    get :static, path: "s/:page_name"
  end
  
  controller :users do
    get :show, path: ":#{User.slug}", as: :user
  end

end