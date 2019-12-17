Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  devise_scope :user do
    get '/about', to: 'static_pages#about'
    get '/login', to: 'users/sessions#new'
  end

  root to: 'records#index'
  get '/privacy', to: 'static_pages#privacy'

  resources :users do
    resource :relationships, only: [:create, :destroy]
    # resorcesにさらにルートを追加. memberは:idのあとに続くという意味
    get :follows, on: :member
    get :followers, on: :member
  end
  resources :records
end
