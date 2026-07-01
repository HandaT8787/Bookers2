Rails.application.routes.draw do
  resource :session, path: "users/sign_in", path_names: { new: ""}
  resources :users, only: [:new, :create, :index, :show, :edit, :update], path_names: {new: 'sign_up'}
  resources :books, only: [:new, :create, :index, :show, :edit, :update]
  
  get "homes/about", to: "homes#about"

  resources :passwords, param: :token
  root "homes#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
