Rails.application.routes.draw do
  root to: 'users#index'
  post   'login'   => 'users#logon'
  delete 'logout'  => 'users#logout'

  get    '/users/search'  => 'users#search', as: 'search_user'
  post   '/users/search'  => 'users#search'
  resources :users

end
