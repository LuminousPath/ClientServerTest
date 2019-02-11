Rails.application.routes.draw do
  resources :scores, only: [:show, :create, :update, :destroy, :index]

  root 'scores#index'
end
