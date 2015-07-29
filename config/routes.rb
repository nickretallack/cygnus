Rails.application.routes.draw do

  resources :comments
  resources :order_forms
  default_url_options  :host => CONFIG["Host"]
  root to: 'users#index'
  post   'login'   => 'users#logon'
  delete 'logout'  => 'users#logout'
  get	 'reset' => 'users#reset', as: 'password_reset'
  post	 'reset' => 'users#reset_confirm'
  get    'reset/:id/:activation' => 'users#reset_return', as: 'send_password_reset'
  patch   'reset/:id/:activation' => 'users#reset_return_confirm'
  get	 'users/:id/activate/:activation' => 'users#activate', as: 'activate_user'

  get	 'images/:id' =>  'images#show'
  get	 'images/:id/thumb/' =>  'images#thumb', as: 'image_thumb'

  get    'users/search'  => 'users#search', as: 'search_user'
  post   'users/search'  => 'users#search'
  resources :users
  resources :pools
  resources :submissions
end
