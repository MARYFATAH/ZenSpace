Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :yoga_classes, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    resources :bookings, only: [:create, :show]
  end

  resources :teachers, only: [:show, :new, :create, :edit, :update, :destroy] do
    resources :reviews, only: [:create]
  end

  resources :yoga_studios, only: [:show, :index, :new, :create, :edit, :update, :destroy] do
    resources :reviews, only: [:create]
  end

  resources :yoga_studio_teachers, only: [:create]

  resources :bookings, only: [:index, :destroy]

  resources :reviews, only: [:destroy]
  # resources :bookings, only: [:show]

  # Path for confirmation page after the booking was successful
  get "bookings/:id/confirmation", to: "bookings#confirmation", as: :confirmation
  resources :yoga_classes, only: [:index, :show, :new, :create]
  get "/admin", to: "pages#admin"

  resources :users do
    # Add a custom route for the confirmation action if needed
    get 'confirmation', on: :member
  end
end
