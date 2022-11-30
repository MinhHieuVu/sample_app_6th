Rails.application.routes.draw do
  root   "static_pages#home"
  get    "/help",    to: "static_pages#help"
  get    "/about",   to: "static_pages#about"
  get    "/contact", to: "static_pages#contact"
  get    "/signup",  to: "users#new"
  get    "/login",   to: "sessions#new"
  post   "/login",   to: "sessions#create"
  delete "/logout",  to: "sessions#destroy"
  resources :users do
    member do
      get :following, :followers, :chat
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :microposts do
    resources :comments
  end
  resources :comments do
    resource :emote, only: :show
  end
  resources :likes, only: [:create, :destroy]

  resources :rooms do
    resources :messages
  end
  resources :relationships, only: [:create, :destroy]
  get "/microposts", to: "static_pages#home"
  # login devise
  # devise_for :users ,
  #            controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

end
