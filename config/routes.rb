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
    member { get :following, :followers, :chat }
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts do
    resources :comments
    member { put "likes" => "comments#vote" }
  end
  resources :comments do
    resource :emote, only: :show
  end

  resources :relationships, only: [:create, :destroy]
  get "/microposts", to: "static_pages#home"
end
