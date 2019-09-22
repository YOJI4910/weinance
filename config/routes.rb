Rails.application.routes.draw do
  get '/about', to: 'static_pages#about'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  root to: 'users#index'
  resources :users do
    resource :relationships, only: [:create, :destroy]
    # resorcesにさらにルートを追加. memberは:idのあとに続くという意味
    get :follows, on: :member
    get :followers, on: :member
  end
  resources :records
end
