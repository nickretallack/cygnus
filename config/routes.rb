Rails.application.routes.draw do
  root to: 'users#index'
  post   'login'   => 'users#logon'
  delete 'logout'  => 'users#logout'
  get	 '/images/:id' =>  'images#show'
  get	 '/images/:id/thumb' =>  'images#thumb', as: 'image_thumb'
  get    '/users/search'  => 'users#search', as: 'search_user'
  post   '/users/search'  => 'users#search'
  resources :users

end
