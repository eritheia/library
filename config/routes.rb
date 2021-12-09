Rails.application.routes.draw do
  devise_for :users
  resources :books do
    collection do
      get :my_books
    end
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
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
