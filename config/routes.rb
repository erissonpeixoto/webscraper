Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  resource :registration, only: [ :new, :create ]

  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"

  get "*path", to: "home#index", constraints: ->(req) { req.format.html? }
end
