Rails.application.routes.draw do
  devise_for :users
  resources :pdfs, only: [:index, :new, :create, :show, :destroy]
  root 'pdfs#index'
end