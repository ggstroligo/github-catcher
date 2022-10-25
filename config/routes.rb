Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :webhook do
    namespace :github do
      resources :issues, only: [:create]
    end
  end

  namespace :api do
    resources :issues do
      resources :events, on: :member
    end
  end
end
