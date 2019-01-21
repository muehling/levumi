Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'application#start'

  post '/login', to: 'application#login'
  post '/logout', to: 'application#logout'

  get '/klassenbuch', to: 'groups#index'

  get '/start', to: 'users#show'

  resource :users

  resources :groups do
    resources :students
    resources :assessments
  end

  resources :tests

end
