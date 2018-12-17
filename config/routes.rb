Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'groups#index'

  get '/klassenbuch', to: 'groups#index'

  resources :groups do
    resources :students
  end

end
