Rails.application.routes.draw do
  resources :purchases
  resources :items
  resources :customers
  resources :merchants
  get '/auth/github/callback', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  get '/login', to: 'sessions#new'

  root to: 'welcome#show'

  resource :import, only: ['new', 'create']
end
