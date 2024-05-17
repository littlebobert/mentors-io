Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :mentors do
    resources :bookings, only: :create
    resources :reviews, only: [:new, :create]
  end

  resources :bookings, only: [:update, :index]

  namespace :mentor do
    resources :bookings, only: :index, as: :mentor_bookings
    resources :bookings, only: :update, as: :mentor_booking
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
