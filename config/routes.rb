Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'application#start'

  #Werbeseite
  get '/info', to: 'application#info'

  #Normaler Login
  post '/login', to: 'application#login'
  post '/logout', to: 'application#logout'

  #Login für SuS
  get '/testen', to: 'application#frontend'
  post '/testen_login', to: 'application#login_frontend'
  get '/testen_login', to: 'application#login_frontend'
  post '/testen_logout', to: 'application#logout_frontend'

  #Masquerading Login durch Admin
  get '/login', to: 'application#start_masquerade'
  get '/logout', to: 'application#end_masquerade'

  #Einfache URLs für andere Seiten/Funktionen
  get '/willkommen', to: 'users#register'
  patch '/willkommen', to: 'users#register'
  get '/passwort', to: 'users#recover'
  post '/passwort', to: 'users#recover'

  # Vue Router routes TBD
  get '/testverwaltung', to: 'users#show'
  get '/testuebersicht', to: 'users#show'
  get '/testexport', to: 'users#show'
  get '/klassenbuch', to: 'users#show'
  get '/start', to: 'users#show'
  get '/materialverwaltung', to: 'users#show'
  get '/materialien', to: 'users#show'
  get '/statistiken', to: 'users#show'
  get '/nutzerverwaltung', to: 'users#show'
  get '/administration', to: 'users#show'
  get '/uebungen', to: 'users#show'
  get '/diagnostik', to: 'users#show'
  get '/diagnostik/:group_id', to: 'users#show'
  get '/diagnostik/:group_id/testdetails/:test_id', to: 'users#show'
  get '/diagnostik/:group_id/testverwaltung', to: 'users#show'

  # API endpoints
  delete '/delete_area/:id', to: 'areas#destroy_safe'
  delete '/delete_self', to: 'users#destroy_self'
  get '/groups/:id/test_data', to: 'groups#get_test_data'
  get '/materials/info', to: 'materials#get_material_data'
  get '/materials/test/:test_id', to: 'materials#get_specific_materials_for_test'
  get '/results/start_demo/:test_id', to: 'results#start_demo'
  get '/tests_meta', to: 'tests#get_tests_meta' # returns metadata for all tests
  get '/tests/info', to: 'tests#get_tests_data'
  get '/tests/items/:id', to: 'tests#get_items'
  get '/users/core_data', to: 'users#get_core_data'
  get '/users/page/:page_number', to: 'users#index_paginated'
  get '/users/search', to: 'users#search'
  get '/users/statistics', to: 'users#statistics'
  post '/check_upload_version', to: 'tests#check_upload_version' # return metadata for single test from uploaded test.json
  post '/renew_login', to: 'application#renew_login'
  put '/groups/:group_id/assessments', to: 'assessments#toggle_all_active'
  put '/users/:id/mail', to: 'users#user_mail'

  get '/registration_error', to: 'application#redirect_to_registration_error'

  #Reguläres REST-Routing
  resources :users

  resources :students do
    resources :results
  end

  resources :groups do
    resources :assessments do
      resources :annotations
      resources :targets
    end
    resources :group_shares
  end

  resources :tests do
  end
  resources :materials
  resources :annotation_categories
  resources :test_types
  resources :areas
  resources :competences
  resources :test_families
end
