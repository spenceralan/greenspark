Rails.application.routes.draw do
  devise_for :users

  resources :home, only: [:index]

  post "stocks/to_buy", to: "stocks#to_buy", as: :stock_to_buy

  resources :stocks do
    resources :transactions
  end

  root "home#index"

end
