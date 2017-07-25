Rails.application.routes.draw do
  devise_for :users

  resources :home, only: [:index]

  resources :stocks do
    resources :transactions
  end

  root "home#index"

end
