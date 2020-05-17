Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # resources :home
  # resources :equipe
  # resources :sobre
  root to: "home#index"
  match 'criar' => 'home#create', via: 'post'
  match 'excluir' => 'home#destroy', via: 'get'
  match 'equipe' => 'equipe#index', via: 'get'
  match 'sobre' => 'sobre#index', via: 'get'
  match 'download' => 'home#download_projeto', via: 'get'
end
