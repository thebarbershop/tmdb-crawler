Rails.application.routes.draw do
  resources :tvs
  resources :movies

  get 'index/index'
  root 'index#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
