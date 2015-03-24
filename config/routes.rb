Rails.application.routes.draw do
  root to: 'users#index'
  resources :users
  post   'login'   => 'users#logon'
  delete 'logout'  => 'users#logout'
  post   'search'  => 'users#search'
end
