Rails.application.routes.draw do
  root "pages#home"
  get "about", to: "pages#about"

  resources :provinces, only: %i[index show]
  resources :airports, only: %i[index show]
  resources :airlines, only: %i[index show]
  resources :reviewers, only: %i[index show]
end
