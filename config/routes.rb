Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :webhook do
    resources :github, only: [:create]
  end

  namespace :api do
    resources :issues do
      resources :events
    end
  end
end
