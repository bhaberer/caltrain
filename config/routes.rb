Rails.application.routes.draw do
  resources :stations
  resources :trains

  root 'trains#index'
end
