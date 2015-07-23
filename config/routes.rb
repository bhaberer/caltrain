Rails.application.routes.draw do
  resources :stations
  resources :trains
  get 'trip', to: 'schedules#trip'

  root 'trains#index'
end
