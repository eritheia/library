Rails.application.routes.draw do
  devise_for :users
  resources :books do
    member do
      put  'return_action'
    end
    collection do
      get :my_books
    end
    resources :reviews
  end
  resources :admins
  resources :readers
  resources :category
  resources :requests do
    member do
      get 'request_action'
    end
  end
  root 'home#index'
  get 'reviews/top_books'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
