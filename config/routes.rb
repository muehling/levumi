Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'application#start'

  #Normaler Login
  post '/login', to: 'application#login'
  post '/logout', to: 'application#logout'

  #Masquerading Login durch Admin
  get '/login', to: 'application#start_masquerade'
  get '/logout', to: 'application#end_masquerade'

  #Einfache URLs für Haupt-SPAs
  get '/klassenbuch', to: 'groups#index'
  get '/start', to: 'users#show'

  #Einfache URLs für andere Seiten/Funktionen
  get '/willkommen', to: 'users#register'
  patch '/willkommen', to: 'users#register'
  get '/passwort', to: 'users#recover'
  post '/passwort', to: 'users#recover'

  #Reguläres REST-Routing
  resources :users

  resources :students do
    collection do
      put '', to: 'students#mass_update'
    end
    resources :results
  end

  resources :groups do
    resources :assessments
  end

  resources :tests

end
