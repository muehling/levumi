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
  post '/recovery_notification', to: 'users#recovery_notification'
  post '/recovery_key_verification', to: 'users#recovery_key_verification'
  get '/recovery_key_verification', to: 'users#recovery_key_verification'
  post '/delete_used_recovery_key', to: 'users#delete_used_recovery_key'

  # Front page
  get '/faq', to: 'application#start'
  get '/forschung', to: 'application#start'
  get '/lehrkraefte', to: 'application#start'
  get '/testinventar', to: 'application#start'

  # Vue Router routes
  get '/administration', to: 'users#show'
  get '/diagnostik', to: 'users#show'
  get '/diagnostik/:group_id', to: 'users#show'
  get '/diagnostik/:group_id/testdetails/:test_id', to: 'users#show'
  get '/diagnostik/:group_id/testdetails/:test_id/einstellungen', to: 'users#show'
  get '/diagnostik/:group_id/testverwaltung', to: 'users#show'
  get '/klassenbuch', to: 'users#show'
  get '/klassenbuch/archiv', to: 'users#show'
  get '/klassenbuch/eigene_klassen', to: 'users#show'
  get '/klassenbuch/eigene_klassen/:group_id', to: 'users#show'
  get '/klassenbuch/eigene_klassen/:group_id/aktionen', to: 'users#show'
  get '/klassenbuch/eigene_klassen/:group_id/liste', to: 'users#show'
  get '/klassenbuch/geteilte_klassen', to: 'users#show'
  get '/klassenbuch/geteilte_klassen/:group_id', to: 'users#show'
  get '/klassenbuch/geteilte_klassen/:group_id/aktionen', to: 'users#show'
  get '/klassenbuch/geteilte_klassen/:group_id/liste', to: 'users#show'
  get '/klassenbuch/neu', to: 'users#show'
  get '/materialien', to: 'users#show'
  get '/materialverwaltung', to: 'users#show'
  get '/neuigkeiten', to: 'users#show'
  get '/nutzerverwaltung', to: 'users#show'
  get '/start', to: 'users#show'
  get '/statistiken', to: 'users#show'
  get '/support', to: 'users#show'
  get '/test-editor', to: 'users#show'
  get '/testexport', to: 'users#show'
  get '/testuebersicht', to: 'users#show'
  get '/testverwaltung', to: 'users#show'
  get '/uebungen', to: 'users#show'

  # API endpoints
  delete '/delete_area/:id', to: 'areas#destroy_safe'
  delete '/delete_self', to: 'users#destroy_self'
  get '/groups/:id/test_data', to: 'groups#get_test_data'
  get '/materials/info', to: 'materials#get_material_data'
  get '/materials/test/:test_id', to: 'materials#get_specific_materials_for_test'
  get '/registration_error', to: 'application#redirect_to_registration_error'
  get '/results/start_demo/:test_id', to: 'results#start_demo'
  get '/student_frontend_data/:id', to: 'students#get_get_student_frontend_data'
  get '/tests_meta', to: 'tests#get_tests_meta' # returns metadata for all tests
  get '/tests/info_attachments/:id', to: 'tests#get_test_info_attachments' # special case: only used by a certain view in analysis-view.vue
  get '/tests/info', to: 'tests#get_tests_data'
  get '/tests/items/:id', to: 'tests#get_items'
  get '/users/core_data', to: 'users#get_core_data'
  get '/users/get_classbook_info', to: 'users#get_classbook_info'
  get '/users/page/:page_number', to: 'users#index_paginated'
  get '/users/search', to: 'users#search'
  get '/users/statistics', to: 'users#statistics'
  post '/check_upload_version', to: 'tests#check_upload_version' # return metadata for single test from uploaded test.json
  post '/renew_login', to: 'application#renew_login'
  post '/students/move_students', to: 'students#move_students'
  put '/groups/:group_id/assessments', to: 'assessments#toggle_all_active'
  put '/users/:id/mail', to: 'users#user_mail'
  post '/groups/:group_id/add_demo_data', to: 'groups#add_demo_data'
  post '/groups/:group_id/delete_demo_data', to: 'groups#delete_demo_data'

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
  resources :news
  resources :support_messages
end
