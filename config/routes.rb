Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'users#home'

  get '/klassenbuch', to: 'groups#index'

  resource :users do
    get 'home'
  end

  resources :groups do
    resources :students
    resources :assessments
  end

  resources :tests

end
