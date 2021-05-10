Rails.application.routes.draw do
  resources :reviews, only: [:index]
  resources :dog_houses, only: [:show]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
